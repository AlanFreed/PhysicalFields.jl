module testPhysicalUnits

using
    ..PhysicalFields

export run

function run(at_dir::String)
    println("Basic SI units, the default system of physical units:")
    println("   length:              ", toString(LENGTH))
    println("   mass:                ", toString(MASS))
    println("   amount of substance: ", toString(GRAM_MOLE))
    println("   time:                ", toString(SECOND))
    println("   temperature:         ", toString(KELVIN))
    println("   electric current:    ", toString(AMPERE))
    println("   light intensity:     ", toString(CANDELA))
    println()
    println("Some other SI types:")
    println("   joule:           ", toString(JOULE))
    println("   kilogram:        ", toString(KILOGRAM))
    println("   meter:           ", toString(METER))
    println("   newton:          ", toString(NEWTON))
    println("   pascal:          ", toString(PASCAL), "\n")
    println("   damping:         ", toString(DAMPING))
    println("   stiffness:       ", toString(STIFFNESS))
    println("   area:            ", toString(AREA))
    println("   volume:          ", toString(VOLUME))
    println("   mass density:    ", toString(MASS_DENSITY))
    println("   displacement:    ", toString(DISPLACEMENT))
    println("   velocity:        ", toString(VELOCITY))
    println("   acceleration:    ", toString(ACCELERATION))
    println("   force:           ", toString(FORCE))
    println("   entropy:         ", toString(ENTROPY))
    println("   entropy/mass:    ", toString(ENTROPYperMASS))
    println("   energy:          ", toString(ENERGY))
    println("   energy/mass:     ", toString(ENERGYperMASS))
    println("   power:           ", toString(POWER))
    println("   stress:          ", toString(STRESS))
    println("   modulus:         ", toString(MODULUS))
    println("   compliance:      ", toString(COMPLIANCE))
    println("   strain:          ", toString(STRAIN))
    println("   strain rate:     ", toString(STRAIN_RATE), "\n")
    force = KILOGRAM + ACCELERATION
    println("   mass + acceleration  = ", toString(force))
    mass = force - ACCELERATION
    println("   force - acceleration = ", toString(mass))
    if STRESS ≠ FORCE
        truth = "true"
    else
        truth = "false"
    end
    println("   stress ≠ force       = ", truth)
    if STRESS == PASCAL
        truth = "true"
    else
        truth = "false"
    end
    println("   stress == pascal     = ", string(truth))
    println()
    println("Basic CGS units:")
    println("   length:              ", toString(CGS_LENGTH))
    println("   mass:                ", toString(CGS_MASS))
    println("   amount of substance: ", toString(CGS_GRAM_MOLE))
    println("   time:                ", toString(CGS_SECOND))
    println("   temperature:         ", toString(CGS_KELVIN))
    println("   electric current:    ", toString(CGS_AMPERE))
    println("   light intensity:     ", toString(CGS_CANDELA))
    println()
    println("Some other CGS units:")
    println("   barye:           ", toString(BARYE))
    println("   centimeter:      ", toString(CENTIMETER))
    println("   dyne:            ", toString(DYNE))
    println("   erg:             ", toString(ERG))
    println("   gram:            ", toString(GRAM), "\n")
    println("   damping:         ", toString(CGS_DAMPING))
    println("   stiffness:       ", toString(CGS_STIFFNESS))
    println("   area:            ", toString(CGS_AREA))
    println("   volume:          ", toString(CGS_VOLUME))
    println("   mass density:    ", toString(CGS_MASS_DENSITY))
    println("   displacement:    ", toString(CGS_DISPLACEMENT))
    println("   velocity:        ", toString(CGS_VELOCITY))
    println("   acceleration:    ", toString(CGS_ACCELERATION))
    println("   force:           ", toString(CGS_FORCE))
    println("   entropy:         ", toString(CGS_ENTROPY))
    println("   entropy/mass:    ", toString(CGS_ENTROPYperMASS))
    println("   energy:          ", toString(CGS_ENERGY))
    println("   energy/mass:     ", toString(CGS_ENERGYperMASS))
    println("   power:           ", toString(CGS_POWER))
    println("   stress:          ", toString(CGS_STRESS))
    println("   modulus:         ", toString(CGS_MODULUS))
    println("   compliance:      ", toString(CGS_COMPLIANCE))
    println("   strain:          ", toString(CGS_STRAIN))
    println("   strain rate:     ", toString(CGS_STRAIN_RATE), "\n")
    force = CGS_MASS + CGS_ACCELERATION
    println("   mass + acceleration  = ", toString(force))
    mass = force - CGS_ACCELERATION
    println("   force - acceleration = ", toString(mass))
    if CGS_STRESS ≠ CGS_FORCE
        truth = "true"
    else
        truth = "false"
    end
    println("   stress ≠ force       = ", truth)
    if CGS_STRESS == BARYE
        truth = "true"
    else
        truth = "false"
    end
    println("   CGS stress == barye  = ", truth)
    println("   CGS stress == pascal = ", CGS_STRESS == PASCAL)
    println("   barye and pascal are equivalent = ", areEquivalent(BARYE, PASCAL))
    println()
    println("Test reading and writing CGS and SI units from/to a JSON file.")
    println()
    my_dir_path = string(at_dir, "/test/files/")
    json_stream = openJSONWriter(my_dir_path, "testPhysicalUnits.json")
    toFile(DIMENSIONLESS, json_stream)
    toFile(CGS_ENTROPY, json_stream)
    toFile(ENTROPY, json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testPhysicalUnits.json")
    unitless = fromFile(PhysicalUnits, json_stream)
    println("Dimensionless units read in as: ", toString(unitless),
        ". It should read as: ", toString(DIMENSIONLESS), ".")
    cgs = fromFile(PhysicalUnits, json_stream)
    println("An instance of type CGS read in as: ", toString(cgs),
        ". It should read as: ", toString(CGS_ENTROPY))
    si = fromFile(PhysicalUnits, json_stream)
    println("An instance of type SI  read in as: ", toString(si),
        ". It should read as: ", toString(ENTROPY), ".")
    close(json_stream)
    return nothing
end

end  # testPhysicalUnits
