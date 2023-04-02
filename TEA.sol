// SPDX-License-Identifier: WTFPL
pragma solidity ^0.8.0;

library TEA {
    // Encrypts a 128-bit plaintext block using a 128-bit key.
    function encrypt(bytes16 v, bytes16 k) internal pure returns (bytes16) {
        // Split the plaintext and key into 32-bit chunks.
        uint32 v0 = uint32(uint128(v));
        uint32 v1 = uint32(uint128(v >> 32));
        uint32 sum = 0;
        uint32 delta = 0x9e3779b9;
        uint32 k0 = uint32(uint128(k));
        uint32 k1 = uint32(uint128(k >> 32));
        uint32 k2 = uint32(uint128(k >> 64));
        uint32 k3 = uint32(uint128(k >> 96));

        // Run the TEA encryption loop for 32 iterations.
        for (uint256 i = 0; i < 32; i++) {
            sum += delta;
            v0 += ((v1 << 4) + k0) ^ (v1 + sum) ^ ((v1 >> 5) + k1);
            v1 += ((v0 << 4) + k2) ^ (v0 + sum) ^ ((v0 >> 5) + k3);
        }

        // Return the encrypted output as a 128-bit block.
        return bytes16(uint128(v0) | (uint128(v1) << 32));
    }

    // Decrypts a 128-bit ciphertext block using a 128-bit key.
    function decrypt(bytes16 v, bytes16 k) internal pure returns (bytes16) {
        // Split the ciphertext and key into 32-bit chunks.
        uint32 v0 = uint32(uint128(v));
        uint32 v1 = uint32(uint128(v >> 32));
        uint32 sum = 0xC6EF3720;
        uint32 delta = 0x9e3779b9;
        uint32 k0 = uint32(uint128(k));
        uint32 k1 = uint32(uint128(k >> 32));
        uint32 k2 = uint32(uint128(k >> 64));
        uint32 k3 = uint32(uint128(k >> 96));

        // Run the TEA decryption loop for 32 iterations.
        for (uint256 i = 0; i < 32; i++) {
            v1 -= ((v0 << 4) + k2) ^ (v0 + sum) ^ ((v0 >> 5) + k3);
            v0 -= ((v1 << 4) + k0) ^ (v1 + sum) ^ ((v1 >> 5) + k1);
            sum -= delta;
        }

        // Return the decrypted output as a 128-bit block.
        return bytes16(uint128(v0) | (uint128(v1) << 32));
    }
}
