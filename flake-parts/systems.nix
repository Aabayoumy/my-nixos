{
  # This tells flake-parts which architectures to generate 
  # perSystem attributes for (like packages, devShells, etc.)
  systems = [ 
    "x86_64-linux" 
    # "aarch64-linux" # Uncomment if you also have an ARM laptop
  ];
}