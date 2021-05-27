function cls()
    t = os.execute("cls")
end
function tan(a)
    return math.tan(math.rad(a))
end
function sin(a)
    return math.sin(math.rad(a))
end
function cos(a)
    return math.cos(math.rad(a))
end

pi = math.pi
trig = {}
thermalExpansion = {}
tensile = {}
carbonEquivalent = {}
ssteel = 15
msteel = 30
brass = 60
ally = 90

function cylinderVolume(r,h)
    return ((pi^2)*r)*h
end
function coneVolume(r,h)
    return cylinderVolume(r,h)/3
end
function trig.chordCSD(d, h)
    ab = d
    bs = h
    --[[
              
        ______a______
       /      |      \
      /               \
     /        |        \
    |                   |
    |         |         |
    |                   |
     \        |s       /
     c\- - - -+- - - -/d 
       \______|______/
              b
    ]]--
    
    
    
    
    
    as = ab-bs
    cs = math.sqrt(as*bs)
    cd = cs*2
    return cd
end
function gusset(l, h, t)
    return math.sqrt((l-t)^2+(h-t)^2)
end
function solveSupportedCylinder(d, h, l, t)
    return trig.chordCSD(d, h), gusset(l, h ,t)
end
function neutralLine(r,a,t)
    return (2*pi*(180-a)*((t*0.4)+r))/360
end
function subtractive(r,a,t)
    --[[
          ____
     ____/   |
    /________| 
    ^   ^Gets this length
    |Given this angle and radius and thickness
    a = the angle of blend halved
    h = radius pluss thickness
    The length is h over tan of a
    ]]--
    a = a/2
    local h = r+t
    return h/tan(a)
end
function solveRATquestions(r,a,t, l1, l2, i)
    sub = subtractive(r,a,t)
    nl = neutralLine(r,a,t)
    length = l1+l2-(2*sub)+nl
    return nl, sub, length, length*i
end

function frustumSolve(l, id, od, verb)
    
    inletRadius = id/2

    outletRadius = od/2
    
    triHeight = l
    triLeg = inletRadius-outletRadius
    
    triHypo = math.sqrt(triLeg^2+triHeight^2)
    
    
    minorRadius = (triHypo/triLeg)*outletRadius 
    
    majorRadius = triHypo+minorRadius
    
    
    sectorCirc = pi*id
    
    mRadCirc = pi*(2*majorRadius)
    
    angle = sectorCirc/mRadCirc*360
    
    halfAng = angle/2
    chord = (majorRadius * sin(halfAng)) * 2
    --chord = ((triHypo+((triHypo/inletRadius-outletRadius)*outletRadius)) * sin(pi*id/(pi*(2*majorRadius))*360)) * 2
    
    --CD = 2([H+([H/Ri-Ro]*Ro) * sin( [pi*Di]/(pi *[2Rm]) )] * 360)
    
    if verb then
        print(string.format("Inlet diameter / 2 = inlet radius = %0.2f", inletRadius))
        
        
        print(string.format("Outlet diameter / 2 = outlet radius = %0.2f", outletRadius))
        
        
        print(string.format("Triangle leg = inlet radius - outlet radius = %0.2f", triLeg))
        
        
        print(string.format("Triangle hypotenuse  = square root of triangle leg ^ 2 +  hieght ^ 2 = %0.2f", triHypo))
        
        
        print(string.format("Minor radius = ( triangle hypotenuse / triangle leg ) * outlet radius =%0.2f", minorRadius))
        
        
        print(string.format("Major radius = Triangle hypotenuse + minor radius = %0.2f", majorRadius))
        
        
        print(string.format("Sector circumference = pi x inlet diameter = %0.2f", sectorCirc))
        
        
        print(string.format("Major radius circumference = pi x (2 x major radius) = %0.2f", mRadCirc))
        
        
        print(string.format("Angle = sector circumference / major radius circumference x 360 = %0.2f", angle))
        
        
        print(string.format("Chord = (major radius x sin( angle / 2 ) ) x 2 = %0.2f", chord))
    end 
    return minorRadius, majorRadius, angle, chord
end


function randomFrustums(n)
    local i = 0
    local array = {}
    for i = 0, n-1, 1 do
        local l = math.random(10, 500)
        local id = math.random(100, 500)
        local od = math.random(10, id)
        
        print(i+1, l, id, od)
        
        local miRad, maRad, angle, chord = frustumSolve(l, id, od)
        
        array[#array+1] = {
            params = {
                l = l,
                id = id,
                od = od
            },
            answers = {
                ["Minor radius"] = miRad,
                ["Major radius"] = maRad,
                ["Angle"] = angle,
                ["Chord"] = chord
            }
        }
    end
    return array
end


function thermalExpansion.deltaL(a, l, t1, t2)
    return l+a*l*(t2-t1), a*l*(t2-t1)
end

function thermalExpansion.findT2(l, l2, t1)
    local deltaL = l2-l
    return deltaL/l*t1
end

function tensile.stress(f, area)
    return f/area
end

function tensile.strain(deformation, nl)
    return deformation/nl
end

function hydroforce(...)
    local arg = {...}
    print(table.concat(arg, ""))
    for k,v in pairs(arg) do print(k, v) end
    a1 = arg[1]
    a2 = arg[2]
    f1 = arg[3]
    return f1/(pi*(a1/2)^2) * (pi*(a2/2)^2)
end

--v = i*r

function volts(i, r)
	return i*r
end

function amps(v, r)
	return v/r 
end

function ohms(v, i)
	return v/i
end

function rpms(d, co)

	return (1000*co)/(pi*d)

end

function carbonEquivalent.IIW(C, Mn, Si, Cr, Mo, V, CU, Ni)
    return C+((Mn+Si)/6)+((Cr+Mo+V)/5)+((CU + Ni)/15)
end

function carbonEquivalent.ISO(C, Mn, Cr, Mo, V, CU, Ni)
    return C+((Mn)/6)+((Cr+Mo+V)/5)+((CU + Ni)/15)
end

--[[

    C = 0.17
    Mn = 1.4
    P = 0.035
    S = 0.035
    N = 0.012
    Cu = 0.55
]]
--[[

dia     30mm
l       8m
force   18kN

strain
Strain = Deformation/Length
Deformation = new length-original length

Strain = epsilon
units =
    Strain = N/a
    Deformation = M
    original length = M

stress = force / area
o(sigma) = F/A

area is crossectional area

Units = 
    Stress = N/m^2 or Mm^-2 or Pa
    Force = N
    Area = M^2
        Perpendicular to force


]]--
