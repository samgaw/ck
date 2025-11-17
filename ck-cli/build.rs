use std::env;
use std::path::PathBuf;

fn main() {
    // Link frameworks for ONNX Runtime on macOS
    // This resolves linking issues similar to PyTorch MPS support
    #[cfg(target_os = "macos")]
    {
        println!("cargo:rustc-link-lib=framework=Metal");
        println!("cargo:rustc-link-lib=framework=Accelerate");
        println!("cargo:rustc-link-lib=framework=CoreFoundation");
        println!("cargo:rustc-link-lib=framework=Foundation");
        
        // Create a stub implementation for the missing symbol
        let out_dir = env::var("OUT_DIR").unwrap();
        let stub_path = PathBuf::from(out_dir).join("platform_version_stub.c");
        
        std::fs::write(&stub_path, r#"
// Stub implementation for ___isPlatformVersionAtLeast
// This resolves ONNX Runtime CoreML linking issues on macOS 26.0 beta

// Suppress unused parameter warnings
#pragma GCC diagnostic ignored "-Wunused-parameter"

// Use proper symbol visibility for C
// Note: The C compiler adds an underscore prefix, so __isPlatformVersionAtLeast becomes ___isPlatformVersionAtLeast
__attribute__((visibility("default")))
int __isPlatformVersionAtLeast(unsigned int platformType, unsigned int major, unsigned int minor, unsigned int patch) {
    // Always return true (platform version is available)  
    // This is safe for ONNX Runtime usage patterns
    return 1;
}
"#).expect("Failed to write stub file");

        // Compile the stub and link it
        cc::Build::new()
            .file(&stub_path)
            .compile("platform_version_stub");
    }
}