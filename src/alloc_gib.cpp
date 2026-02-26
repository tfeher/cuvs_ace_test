#include <cstdlib>
#include <cstring>
#include <iostream>

int main(int argc, char* argv[]) {
  if (argc < 2) {
    std::cerr << "Usage: " << (argc ? argv[0] : "alloc_gib") << " <GiB>\n";
    return EXIT_FAILURE;
  }
  int gib = std::atoi(argv[1]);
  if (gib <= 0) {
    std::cerr << "GiB must be a positive integer\n";
    return EXIT_FAILURE;
  }
  const size_t bytes = static_cast<size_t>(gib) * (1ULL << 30);
  std::cout << "Allocating " << gib << " GiB (" << bytes << " bytes)...\n";
  void* mem = std::malloc(bytes);
  if (!mem) {
    std::cerr << "malloc failed\n";
    return EXIT_FAILURE;
  }
  std::memset(mem, 0, bytes);
  std::cout << "Done. Press Enter to exit.\n";
  std::cin.get();
  std::free(mem);
  return EXIT_SUCCESS;
}
