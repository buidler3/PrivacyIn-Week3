#!/bin/bash

cd contracts

mkdir BinSum

if [ -f ./powersOfTau28_hez_final_12.ptau ]; then
    echo "powersOfTau28_hez_final_12.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_12.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_12.ptau
fi

echo "Compiling BinSum.circom..."

# compile circuit

circom ../circuits/BinSum.circom --r1cs --wasm --sym -o BinSum
snarkjs r1cs info BinSum/BinSum.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup BinSum/BinSum.r1cs powersOfTau28_hez_final_12.ptau BinSum/circuit_0000.zkey
snarkjs zkey contribute BinSum/circuit_0000.zkey BinSum/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey BinSum/circuit_final.zkey BinSum/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier BinSum/circuit_final.zkey Verifier.sol

cd ..