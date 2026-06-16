allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Force consistent JVM target across ALL subprojects (including Flutter plugins like receive_sharing_intent)
subprojects {
    afterEvaluate {
        // Force Java compile options
        @Suppress("UNCHECKED_CAST")
        (project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension)?.compileOptions {
            sourceCompatibility = JavaVersion.VERSION_17
            targetCompatibility = JavaVersion.VERSION_17
        }

        // Force Kotlin JVM target using new compilerOptions DSL
        project.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinJvmCompile>().configureEach {
            compilerOptions {
                jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
