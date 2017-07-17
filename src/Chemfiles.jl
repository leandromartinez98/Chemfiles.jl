# Copyright (c) Guillaume Fraux 2015
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module Chemfiles
    module lib
        const ROOT = dirname(@__FILE__)
        const depsfile = normpath(joinpath(ROOT, "..", "deps", "deps.jl"))
        if isfile(depsfile)
            include(depsfile)
        else
            error("Chemfiles is not installed (the '$depsfile' file is missing).\nPlease run Pkg.build(\"Chemfiles\")")
        end
        include("generated/types.jl")
        include("generated/cdef.jl")
    end

    include("errors.jl")

    export Trajectory, Topology, Atom, UnitCell, Frame, Selection, Residue

    function version()
        unsafe_string(lib.chfl_version())
    end

    function strip_null(string)
        for i in 1:length(string)
            if string[i] == '\0'
                return string[1:i-1]
            end
        end
        throw(ChemfilesError("A C string is not NULL terminated"))
    end

    """
    A ``Trajectory`` represents a simulation file on the hard drive. It can read
    or write one or many ``Frame`` to this file. The file format can be
    automatically determined from the extention, or manually specified.
    """
    type Trajectory
        handle :: Ptr{lib.CHFL_TRAJECTORY}
        function Trajectory(ptr::Ptr{lib.CHFL_TRAJECTORY})
            check(ptr)
            this = new(ptr)
            finalizer(this, free)
            return this
        end
    end

    type Topology
        handle :: Ptr{lib.CHFL_TOPOLOGY}
        function Topology(ptr::Ptr{lib.CHFL_TOPOLOGY})
            check(ptr)
            this = new(ptr)
            finalizer(this, free)
            return this
        end
    end

    """
    An ``Atom`` is a particle in the current ``Frame``.

    An atom stores the following atomic properties:
      - atom name
      - atom type
      - atom mass
      - atom charge

    The atom name is usually an unique identifier (“H1”, “C_a”) while the atom type will be shared between all particles of the same type: “H”, “Ow”, “CH3”.
    """
    type Atom
        handle :: Ptr{lib.CHFL_ATOM}
        function Atom(ptr::Ptr{lib.CHFL_ATOM})
            check(ptr)
            this = new(ptr)
            finalizer(this, free)
            return this
        end
    end

    type UnitCell
        handle :: Ptr{lib.CHFL_CELL}
        function UnitCell(ptr::Ptr{lib.CHFL_CELL})
            check(ptr)
            this = new(ptr)
            finalizer(this, free)
            return this
        end
    end

    type Frame
        handle :: Ptr{lib.CHFL_FRAME}
        function Frame(ptr::Ptr{lib.CHFL_FRAME})
            check(ptr)
            this = new(ptr)
            finalizer(this, free)
            return this
        end
    end

    type Selection
        handle :: Ptr{lib.CHFL_SELECTION}
        function Selection(ptr::Ptr{lib.CHFL_SELECTION})
            check(ptr)
            this = new(ptr)
            finalizer(this, free)
            return this
        end
    end

    type Residue
        handle :: Ptr{lib.CHFL_RESIDUE}
        function Residue(ptr::Ptr{lib.CHFL_RESIDUE})
            check(ptr)
            this = new(ptr)
            finalizer(this, free)
            return this
        end
    end

    include("Atom.jl")
    include("Frame.jl")
    include("Topology.jl")
    include("Trajectory.jl")
    include("UnitCell.jl")
    include("Selection.jl")
    include("Residue.jl")
end
