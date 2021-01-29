# Wing Structural Optimization
A set of tools for wing structural optimization in Matlab.
This code was orginally developed for the SAE Aerodesign Brasil competition at
the UFMG's Aerodesign Team (Uai, Sô! Fly!).

## TODO
 - [ ] Refactor the code to be more modular.
 - [ ] Full documentation corverge.

## Improvements
 - [ ] Implement others beam cross-sections.
 - [ ] Implement foil geometric torsion.
 - [ ] Implement wing sweep.
 - [ ] Implement foil aerodynamic torsion.
 - [ ] Implement composite ply analysis.

## Next Version
 - [ ] Migration to Python.
 - [ ] Migration to OpenMDAO.

## Methodology

This approach utilizes the basic elastic equations to evaluate structural stress under a set of specified load conditions.

 - Descritize the wing foil and spar cross-section in N sections given a full defined wing and spar geometry.
 - Interpolate wing foil section and spar cross-section geometry given the a set of M concetrated loads along the span.
 - Evaluate cross-section properties.
 - Calculates the M internal loads along the span.
 - Evaluate the maximum stress in each cross-section.
 - Find the critical stress value acting on the spar.

## References

 - [Greco, M. - Resistência dos Materiais: Uma Abordagem Sintética](https://www.amazon.com.br/Resist%C3%AAncia-dos-Materiais-Marcelo-Greco/dp/8535274588)
 - [Megson, T.H.G. - Aircraft Structures for Engineering Students](https://www.amazon.com.br/Aircraft-Structures-Engineering-Students-T-H-G/dp/0081009143)
 - Airframe and Equipment Engineering Report No. 45, AD-A955 270, 1955
 - [Mathworks Matlab Optimization Docs](https://www.mathworks.com/help/gads/index.html?s_tid=CRUX_lftnav)
 
 
 
