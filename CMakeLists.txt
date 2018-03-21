cmake_minimum_required(VERSION 2.8)

add_subdirectory("../sources/SolARFramework" "SolARFramework")
add_subdirectory("../sources/Modules/SolARModuleOpenCV" "Modules/SolARModuleOpenCV")
add_subdirectory("../sources/Modules/SolARModuleNonFreeOpenCV" "Modules/SolARModuleNonFreeOpenCV")
add_subdirectory("../sources/Modules/SolARModuleTools" "Modules/SolARModuleTools")

add_subdirectory("../sources/Samples/NaturalImageMarker/Static" "Samples/NaturalImageMarker/Static")
add_subdirectory("../sources/Samples/FiducialMarker/Static" "Samples/FiducialMarker/Static")

