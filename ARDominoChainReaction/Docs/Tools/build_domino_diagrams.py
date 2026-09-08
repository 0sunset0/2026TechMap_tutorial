"""Generate editable SVG diagrams for the domino entity tutorial (stdlib only)."""
from pathlib import Path
from html import escape

OUT = Path(__file__).resolve().parents[2] / 'ARDominoChainReaction.docc/Resources'

def text(x, y, value, size=24, color='#172b4d', anchor='start'):
    return f'<text x="{x}" y="{y}" font-size="{size}" fill="{color}" text-anchor="{anchor}">{escape(value)}</text>'

def box(x, y, w, h, title, lines=(), fill='#eef5ff'):
    result = f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="16" fill="{fill}" stroke="#bfd0e5" stroke-width="2"/>'
    result += text(x+22, y+42, title, 25)
    for i, line in enumerate(lines):
        result += text(x+22, y+82+i*32, line, 20, '#455b75')
    return result

def arrow(x1, y1, x2, y2):
    return f'<path d="M{x1} {y1} L{x2} {y2}" fill="none" stroke="#1670e8" stroke-width="4" marker-end="url(#arrow)"/>'

def domino(x, y, red=False):
    # Front face width:height is exactly 2:5; depth is half the width.
    front, side, top = ('#e54d49','#b72d31','#f7857b') if red else ('#e2eaf3','#a6b8cd','#f4f7fb')
    return (f'<path d="M{x} {y} l40 -24 h160 l-40 24z" fill="{top}" stroke="#64748b"/>'
            f'<path d="M{x+160} {y} l40 -24 v400 l-40 24z" fill="{side}" stroke="#64748b"/>'
            f'<rect x="{x}" y="{y}" width="160" height="400" fill="{front}" stroke="#64748b"/>')

def save(name, title, subtitle, body):
    svg = ('<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="720" viewBox="0 0 1200 720">'
           '<defs><marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0 0 L10 5 L0 10z" fill="#1670e8"/></marker></defs>'
           '<rect width="1200" height="720" rx="24" fill="#fafcff"/>'
           '<g font-family="-apple-system, BlinkMacSystemFont, Apple SD Gothic Neo, sans-serif">'
           +text(56,72,title,34)+text(56,114,subtitle,21,'#52677e')+body+'</g></svg>')
    (OUT/name).write_text(svg)

save('ecs-entity.svg','Entity · 객체의 기본 틀','모양이나 물리 기능은 필요한 부품을 붙여 구성합니다.',
     box(140,215,920,310,'Entity',('위치 · 방향 · 크기','부모와 자식 관계','예: 도미노 하나를 나타낼 객체')))

save('ecs-components.svg','Component · 객체에 붙이는 데이터','도미노에는 보이는 모습과 충돌·물리 정보를 함께 구성합니다.',
     box(65,280,225,130,'Entity',('도미노',))+arrow(305,345,355,345)
     +box(380,175,740,120,'ModelComponent',('Mesh + Materials · 모양과 재질',))
     +box(380,315,740,120,'CollisionComponent',('충돌할 범위',))
     +box(380,455,740,120,'PhysicsBodyComponent',('질량 · 물리 모드',)))

save('ecs-system.svg','System · 데이터를 바탕으로 동작 처리','필요한 물리 컴포넌트를 갖추면 내장 물리 시스템이 처리합니다.',
     box(55,230,340,190,'도미노의 컴포넌트',('CollisionComponent','PhysicsBodyComponent'))
     +arrow(410,325,465,325)+box(485,230,300,190,'내장 물리 System',('시뮬레이션 갱신',))
     +arrow(800,325,855,325)+box(875,230,270,190,'동작',('낙하 · 충돌','위치와 회전 변화')))

save('ecs-composition.svg','필요한 부품만 조합하기','같은 Entity 구조라도 역할에 따라 컴포넌트 구성이 달라집니다.',
     box(55,195,530,370,'도미노',('ModelComponent: 모양 + 재질','CollisionComponent: 충돌 범위','PhysicsBodyComponent: dynamic','보이고, 움직이며, 부딪힙니다.'))
     +box(615,195,530,370,'보이지 않는 물리 바닥',('ModelComponent 없이 구성','CollisionComponent: 충돌 범위','PhysicsBodyComponent: static','움직이지 않는 받침대입니다.'), '#f0f8f3'))

save('domino-mesh-dimensions.svg','Mesh · 도미노의 모양','코드의 단위는 미터입니다. 정면의 너비:높이는 2:5입니다.',
     domino(235,215)+arrow(160,600,160,215)+text(125,415,'Y',24)
     +text(55,460,'높이 0.2m',20)+arrow(235,655,395,655)+text(250,695,'너비 0.08m · X',20)
     +box(620,220,490,220,'generateBox',('width: 0.08 → X축 8cm','height: 0.2 → Y축 20cm','depth: 0.04 → Z축 4cm'))
     +text(620,495,'원점은 박스의 중심입니다.',23)
     +text(620,535,'바닥에 놓을 때 높이를 보정합니다.',23))

save('domino-material.svg','Material · 도미노의 표면','세 값을 설정해 빨간색 비금속 재질을 만듭니다.',
     domino(155,210,True)
     +box(470,185,665,125,'baseColor = .red',('표면의 고유색을 빨간색으로 설정',))
     +box(470,330,665,125,'roughness = 0.4',('낮을수록 반사가 또렷하고, 높을수록 흐려짐',))
     +box(470,475,665,125,'metallic = 0',('금속이 아닌 표면으로 설정',)))

save('domino-model-entity.svg','ModelEntity · 모양과 재질 결합','겉모습 완성 → 다음 절에서 충돌과 물리 기능을 추가합니다.',
     box(60,230,295,155,'Mesh',('8 × 20 × 4cm','직육면체'))
     +text(385,327,'+',42)+box(440,230,290,155,'Material',('빨간색','비금속 표면'))
     +arrow(750,308,815,308)+domino(875,195,True)
     +text(845,650,'ModelEntity',27)
     +text(60,510,'ModelEntity(mesh: mesh, materials: [material])',26)
     +text(60,555,'아직 중력과 충돌은 적용하지 않았습니다.',24,'#52677e'))

save('physics-floor.svg','보이지 않는 물리 바닥 완성','감지된 평면에 충돌 범위와 움직이지 않는 물리 바디를 구성했습니다.',
     '<path d="M70 510 L615 320 L1140 505 L595 700Z" fill="#e5e1db" stroke="#b9b3aa" stroke-width="2"/>'
     +'<path d="M235 535 L625 395 L945 510 L555 650Z" fill="#1684f5" fill-opacity="0.22" stroke="#1670e8" stroke-width="3" stroke-dasharray="10 7"/>'
     +domino(440,175,True)
     +box(735,175,410,140,'빨간 도미노',('PhysicsBodyComponent','mode: .dynamic'))
     +arrow(730,255,625,320)
     +box(45,185,330,145,'물리 바닥',('CollisionComponent','물리 바디: .static'))
     +arrow(205,345,340,500)
     +text(890,640,'실제 바닥',23,'#60594f')
     +text(55,685,'파란 영역은 설명을 위한 표시이며, 앱 화면에는 보이지 않습니다.',21,'#455b75'))

print('Generated 8 tutorial SVG diagrams')
