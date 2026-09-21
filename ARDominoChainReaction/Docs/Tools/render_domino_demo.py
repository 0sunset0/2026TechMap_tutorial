"""Render a landscape Blender rigid-body demo using the project's USDZ model.

Run: Blender -b --python render_domino_demo.py -- /tmp/techmap-domino-render
Encode frame PNGs with FFmpeg palettegen/paletteuse at 24 fps.
"""
import bpy
import math
import sys
from pathlib import Path
from mathutils import Vector

ROOT = Path(__file__).resolve().parents[2]
OUT = Path(sys.argv[sys.argv.index('--') + 1])
OUT.mkdir(parents=True, exist_ok=True)
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)
bpy.ops.wm.usd_import(filepath=str(ROOT / 'Sources/ARDominoChainReaction/domino.usdz'))
source = next(o for o in bpy.context.selected_objects if o.type == 'MESH')
mesh = source.data.copy()
mesh.transform(source.matrix_world)
for obj in list(bpy.data.objects):
    bpy.data.objects.remove(obj, do_unlink=True)

# Normalize the imported model into Blender's Z-up coordinates.
lo = Vector(tuple(min(v.co[i] for v in mesh.vertices) for i in range(3)))
hi = Vector(tuple(max(v.co[i] for v in mesh.vertices) for i in range(3)))
center = (lo + hi) / 2
long_axis = max(range(3), key=lambda i: hi[i] - lo[i])
for v in mesh.vertices:
    p = v.co - center
    if long_axis == 1:
        p = Vector((p.x, -p.z, p.y))
    v.co = p

scene = bpy.context.scene
scene.render.engine = 'CYCLES'
scene.cycles.samples = 12
scene.cycles.use_denoising = True
scene.render.resolution_x = 960
scene.render.resolution_y = 540
scene.render.resolution_percentage = 100
scene.render.fps = 24
scene.frame_end = 96
scene.world.color = (0.35, 0.35, 0.35)
scene.view_settings.view_transform = 'AgX'

for i in range(11):
    obj = bpy.data.objects.new('Wood domino %02d' % i, mesh.copy())
    scene.collection.objects.link(obj)
    obj.location = (0, (i - 5) * 0.105, 0.101)
    bpy.context.view_layer.objects.active = obj
    obj.select_set(True)
    bpy.ops.rigidbody.object_add()
    obj.rigid_body.mass = 0.07
    obj.rigid_body.collision_shape = 'BOX'
    obj.rigid_body.use_margin = True
    obj.rigid_body.collision_margin = 0.0005
    obj.rigid_body.friction = 0.65
    obj.rigid_body.restitution = 0.02
    if i == 0:
        obj.rigid_body.kinematic = True
        obj.keyframe_insert('rigid_body.kinematic', frame=1)
        obj.keyframe_insert('rotation_euler', frame=18)
        obj.keyframe_insert('location', frame=18)
        angle = math.radians(24)
        obj.rotation_euler.x = -angle
        obj.location.y += 0.1 * math.sin(angle)
        obj.location.z = 0.1 * math.cos(angle) + 0.02 * math.sin(angle) + 0.001
        obj.keyframe_insert('rotation_euler', frame=26)
        obj.keyframe_insert('location', frame=26)
        obj.keyframe_insert('rigid_body.kinematic', frame=26)
        obj.rigid_body.kinematic = False
        obj.keyframe_insert('rigid_body.kinematic', frame=27)
    obj.select_set(False)

# A fine irregular, matte gray carpet inspired by the real-device recording.
mat = bpy.data.materials.new('Gray loop carpet')
mat.use_nodes = True
nodes, links = mat.node_tree.nodes, mat.node_tree.links
bsdf = nodes.get('Principled BSDF')
bsdf.inputs['Roughness'].default_value = 0.95
tex = nodes.new('ShaderNodeTexNoise')
tex.inputs['Scale'].default_value = 300
tex.inputs['Detail'].default_value = 2
coord = nodes.new('ShaderNodeTexCoord')
links.new(coord.outputs['Object'], tex.inputs['Vector'])
ramp = nodes.new('ShaderNodeValToRGB')
ramp.color_ramp.elements[0].position = 0.22
ramp.color_ramp.elements[0].color = (0.08, 0.085, 0.082, 1)
ramp.color_ramp.elements[1].position = 0.78
ramp.color_ramp.elements[1].color = (0.30, 0.31, 0.30, 1)
links.new(tex.outputs['Fac'], ramp.inputs[0])
links.new(ramp.outputs[0], bsdf.inputs['Base Color'])
bump = nodes.new('ShaderNodeBump')
bump.inputs['Strength'].default_value = 0.45
bump.inputs['Distance'].default_value = 0.0015
links.new(tex.outputs['Fac'], bump.inputs['Height'])
links.new(bump.outputs[0], bsdf.inputs['Normal'])
bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, -0.025))
floor = bpy.context.object
floor.name = 'Carpet floor'
floor.dimensions = (200, 200, 0.05)
bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
floor.data.materials.append(mat)
bpy.ops.rigidbody.object_add()
floor.rigid_body.type = 'PASSIVE'
floor.rigid_body.friction = 0.8
floor.rigid_body.collision_margin = 0.0005

def aim(obj, point):
    obj.rotation_euler = (Vector(point) - obj.location).to_track_quat('-Z', 'Y').to_euler()

bpy.ops.object.camera_add(location=(1.38, -1.45, 1.10))
camera = bpy.context.object
aim(camera, (0, 0, 0.075))
camera.data.type = 'ORTHO'
camera.data.ortho_scale = 1.72
scene.camera = camera
for location, energy, size in [((1, -0.5, 2.4), 160, 2.0), ((-1, 1, 1.6), 70, 1.5)]:
    bpy.ops.object.light_add(type='AREA', location=location)
    light = bpy.context.object
    light.data.energy = energy
    light.data.shape = 'DISK'
    light.data.size = size
    aim(light, (0, 0, 0))

world = scene.rigidbody_world
world.substeps_per_frame = 10
world.solver_iterations = 30
world.point_cache.frame_end = scene.frame_end
with bpy.context.temp_override(point_cache=world.point_cache):
    bpy.ops.ptcache.bake(bake=True)
scene.render.image_settings.file_format = 'PNG'
scene.render.filepath = str(OUT / 'frame-')
bpy.ops.wm.save_as_mainfile(filepath=str(OUT / 'domino-demo.blend'))
if '--preview' in sys.argv:
    for frame in (1, 38, 65, 90):
        scene.frame_set(frame)
        scene.render.filepath = str(OUT / ('preview-%03d.png' % frame))
        bpy.ops.render.render(write_still=True)
else:
    bpy.ops.render.render(animation=True)
