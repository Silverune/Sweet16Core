# Sweet16 Core Library Fork

Subset collection of routines from the Core library for use for 6502 development.   Most routine are presented as Kick Assembler "macros" so that inclusion of the Core library does not increase the size of the project.   To use create a instance and then place the desired macro at that memory location.   e.g.,

{{{
    sweet16_instance:
        Sweet16()

}}}
