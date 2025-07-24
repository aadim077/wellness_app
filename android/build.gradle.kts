// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    // This plugin is typically applied to the app module, not the top-level build.gradle.
    // However, if your project structure requires it here for some reason, keep it.
    // The 'apply false' means it's declared here but not applied to this file itself.
    id("com.google.gms.google-services") version "4.4.3" apply false
}

// Configuration to apply to all projects (including your app and any plugins)
allprojects {
    repositories {
        google() // Google's Maven repository
        mavenCentral() // Maven Central repository
    }

    // This block configures all Java compilation tasks across all subprojects
    // to suppress specific warnings related to obsolete Java options (like Java 8 warnings).
    tasks.withType<org.gradle.api.tasks.compile.JavaCompile>().configureEach {
        options.compilerArgs.add("-Xlint:-options")
    }
}

// Define a new build directory for the root project.
// This moves the default 'build' directory out of the root project folder
// to a custom location, typically for cleaner project structure.
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Configure subprojects to also use a custom build directory
// located within the 'newBuildDir' defined above.
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// This line ensures that all subprojects are evaluated after the ':app' project.
// This can be important for dependency resolution order, especially in complex multi-module setups.
subprojects {
    project.evaluationDependsOn(":app")
}

// Register a 'clean' task that deletes the entire custom build directory.
// This is useful for ensuring a fresh build by removing all generated build artifacts.
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
