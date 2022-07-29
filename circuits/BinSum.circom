pragma circom 2.0.0;

template BinSum() {
    signal input in[2][256];
    signal output out[257];

    var lin = 0;
    var lout = 0;

    var k;
    var e2; // number of carries

    e2 = 1;
    for (k=0; k<256; k++) {
        in[0][k] * (in[0][k] - 1) === 0; // constraints for input
        in[1][k] * (in[1][k] - 1) === 0;

        lin += in[0][k] * e2 + in[1][k] * e2;
        e2 = e2 + e2; 
    }

    e2 = 1;
    for (k=0; k<257; k++) {
        out[k] <-- (lin >> k) & 1;

        out[k] * (out[k] - 1) === 0;
        
        lout += out[k] * e2;

        e2 = e2 + e2;
    }

    lin === lout;
}

component main = BinSum();