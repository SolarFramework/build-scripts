cmake_minimum_required(VERSION 2.8)

add_subdirectory("../sources/SolARFramework" "SolARFramework")
add_subdirectory("../sources/Modules/SolARModuleOpenCV" "Modules/SolARModuleOpenCV")
add_subdirectory("../sources/Modules/SolARModuleNonFreeOpenCV" "Modules/SolARModuleNonFreeOpenCV")
add_subdirectory("../sources/Modules/SolARModuleTools" "Modules/SolARModuleTools")
add_subdirectory("../sources/Modules/SolARModuleOpenGL" "Modules/SolARModuleOpenGL")

add_subdirectory("../sources/Samples/NaturalImageMarker/Dynammic" "Samples/NaturalImageMarker/Dynamic")
add_subdirectory("../sources/Samples/FiducialMarker/Dynamic" "Samples/FiducialMarker/Dynamic")
add_subdirectory("../sources/Samples/Sample-Triangulation" "Samples/Sample-Triangulation")
add_subdirectory("../sources/Samples/Sample-Slam" "Samples/Sample-Slam")