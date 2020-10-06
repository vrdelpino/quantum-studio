// Our namespace will be Qrng (following Microsoft Example)
namespace Qrng {
    //Including Microsoft Packages needed
    open Microsoft.Quantum.Intrinsic;

    // What we do here is to apply Hadamard to a QBit and measure it.
    // Being in superposition, this QBit will read to 0 around 50% of the time
    // the other 50% will be 1.
    operation SampleQuantumRandomNumberGenerator() : Result {
        using (q = Qubit())  { // Allocate a qubit.
            H(q);             // Put the qubit to superposition. It now has a 50% chance of being 0 or 1.
            let r = M(q);     // Measure the qubit value.
            Reset(q);
            return r;
        }
    }
}