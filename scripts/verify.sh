#!bin/bash -e

CIRCUIT_NAME=BinSum

cd contracts/${CIRCUIT_NAME}

prove_verify() {
    node ${CIRCUIT_NAME}_js/generate_witness.js ${CIRCUIT_NAME}_js/$CIRCUIT_NAME.wasm ../../input_${1}.json witness_${1}.wtns
    echo -e "generate witness for test${1} ✔\n" 
    
    echo -e "start generating proof for test${1} ✔\n"
    snarkjs groth16 prove circuit_final.zkey witness_${1}.wtns proof_${1}.json public_${1}.json
    
    echo -e "start verifying proof for test${1} ✔\n"
    snarkjs groth16 verify verification_key.json public_${1}.json proof_${1}.json
    
    cd ../..
    echo -e "\nend verifying proof for test${1} ✔\n"
}

main() {
    
    prove_verify 1
    # prove_verify 2
    
}

main

