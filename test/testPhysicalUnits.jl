module testPhysicalUnits

using
    ..PhysicalFields

export run

function run(at_dir::String)
    println("CGS units:")
    println("   barye:           ", toString(BARYE))
    println("   centigrade:      ", toString(CENTIGRADE))
    println("   centimeter:      ", toString(CENTIMETER))
    println("   dyne:            ", toString(DYNE))
    println("   erg:             ", toString(ERG))
    println("   gram:            ", toString(GRAM), "\n")
    println("   mass:            ", toString(CGS_MASS))
    println("   damping:         ", toString(CGS_DAMPING))
    println("   stiffness:       ", toString(CGS_STIFFNESS))
    println("   length:          ", toString(CGS_LENGTH))
    println("   area:            ", toString(CGS_AREA))
    println("   volume:          ", toString(CGS_VOLUME))
    println("   time:            ", toString(CGS_SECOND))
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
    println("   stress == barye      = ", string(truth), "\n")
    println("SI units:")
    println("   joule:           ", toString(JOULE))
    println("   Kelvin:          ", toString(KELVIN))
    println("   kilogram:        ", toString(KILOGRAM))
    println("   meter:           ", toString(METER))
    println("   newton:          ", toString(NEWTON))
    println("   pascal:          ", toString(PASCAL), "\n")
    println("   mass:            ", toString(SI_MASS))
    println("   damping:         ", toString(SI_DAMPING))
    println("   stiffness:       ", toString(SI_STIFFNESS))
    println("   length:          ", toString(SI_LENGTH))
    println("   area:            ", toString(SI_AREA))
    println("   volume:          ", toString(SI_VOLUME))
    println("   time:            ", toString(SI_SECOND))
    println("   mass density:    ", toString(SI_MASS_DENSITY))
    println("   displacement:    ", toString(SI_DISPLACEMENT))
    println("   velocity:        ", toString(SI_VELOCITY))
    println("   acceleration:    ", toString(SI_ACCELERATION))
    println("   force:           ", toString(SI_FORCE))
    println("   entropy:         ", toString(SI_ENTROPY))
    println("   entropy/mass:    ", toString(SI_ENTROPYperMASS))
    println("   energy:          ", toString(SI_ENERGY))
    println("   energy/mass:     ", toString(SI_ENERGYperMASS))
    println("   power:           ", toString(SI_POWER))
    println("   stress:          ", toString(SI_STRESS))
    println("   modulus:         ", toString(SI_MODULUS))
    println("   compliance:      ", toString(SI_COMPLIANCE))
    println("   strain:          ", toString(SI_STRAIN))
    println("   strain rate:     ", toString(SI_STRAIN_RATE), "\n")
    force = KILOGRAM + SI_ACCELERATION
    println("   mass + acceleration  = ", toString(force))
    mass = force - SI_ACCELERATION
    println("   force - acceleration = ", toString(mass))
    if SI_STRESS ≠ SI_FORCE
        truth = "true"
    else
        truth = "false"
    end
    println("   stress ≠ force       = ", truth)
    if SI_STRESS == PASCAL
        truth = "true"
    else
        truth = "false"
    end
    println("   stress == pascal     = ", string(truth))
    if BARYE == PASCAL
        truth = "true"
    else
        truth = "false"
    end
    println("   barye  == pascal     = ", string(truth))
    println()
    println("Test reading and writing CGS and SI units from/to a JSON file.")
    println()
    my_dir_path = string(at_dir, "/test/files/")
    json_stream = openJSONWriter(my_dir_path, "testPhysicalUnits.json")
    toFile(Dimensionless(), json_stream)
    toFile(CGS_ENTROPY, json_stream)
    toFile(SI_ENTROPY, json_stream)
    close(json_stream)
    json_stream = openJSONReader(my_dir_path, "testPhysicalUnits.json")
    unitless = fromFile(PhysicalUnits, json_stream)
    println("Dimensionless units read in as: ", toString(unitless),
        ". It should read as: ", toString(Dimensionless()), ".")
    cgs = fromFile(PhysicalUnits, json_stream)
    println("An instance of type CGS read in as: ", toString(cgs),
        ". It should read as: ", toString(CGS_ENTROPY))
    si = fromFile(PhysicalUnits, json_stream)
    println("An instance of type SI  read in as: ", toString(si),
        ".  It should read as: ", toString(SI_ENTROPY), ".")
    close(json_stream)
    return nothing
end

end  # testPhysicalUnits
