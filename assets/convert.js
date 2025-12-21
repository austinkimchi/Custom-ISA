// PARAMETERS
const COMMENT_DELIM = "//";

const fs = require('fs');
const readline = require('readline').createInterface({
    input: process.stdin,
    output: process.stdout
});
readline.question('Enter the path to the assembly file: ', filePath => {
    // Read the file
    fs.readFile(filePath, 'utf8', (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            readline.close();
            return;
        }
        // Process the file line by line
        const lines = data.split('\n');
        let outputLines = [];
        for (let line of lines) {
            // Ignore comments
            if (line.includes(COMMENT_DELIM)) {
                line = line.split(COMMENT_DELIM)[0].trim();
            }
            if (line === '') continue; // Skip empty lines

            // Match instruction pattern
            // remove extra spaces
            line = line.replace(/\s+/g, ' ');
            const match = line.match(/<(\d+)>:\s+([A-Z]+)(?:\s+([x0-9-,\s]+))?/);
            if (match) {
                const address = parseInt(match[1]);
                const opcode = match[2];
                let operands = undefined;
                if (match[3])
                    operands = match[3].split(',').map(op => op.trim());
                // Convert to binary
                const binaryInstruction = convertToBinary(opcode, operands);
                outputLines.push(`memory[${address}] = 32'b${binaryInstruction};`);
            }
        }
        // Write to output file
        const outputFilePath = filePath.replace('.asm', '_convert.txt');
        fs.writeFile(outputFilePath, outputLines.join('\n'), err => {
            if (err) {
                console.error('Error writing file:', err);
            } else {
                console.log('File converted successfully:', outputFilePath);
            }
            readline.close();
        });
    });
});

function convertToBinary(opcode, operands) {
    // FORMAT: Y(10 bits)_RD(6 bits)_RS(6 bits)_RT(6 bits)_OPCODE(4 bits)
    const opcodeMap = {
        'NOP': '0000',
        'SVPC': '1111',
        'LD': '1110',
        'ST': '0011',
        'ADD': '0100',
        'INC': '0101',
        'NEG': '0110',
        'SUB': '0111',
        'J': '1000',
        'BRZ': '1001',
        'BRN': '1010'
    };
    let Y = '0000000000';
    let RD = '000000';
    let RS = '000000';
    let RT = '000000';
    let OPCODE = opcodeMap[opcode];
    switch (opcode) {
        case 'NOP':
            // No operands
            break;
        case 'SVPC':
            // Two operand: RD, Y
            RD = registerToBinary(operands[0]);
            Y = immediateToBinary(operands[1], 10);
            break;
        case 'LD':
            // Three operands: RD, RS, Y
            RD = registerToBinary(operands[0]);
            RS = registerToBinary(operands[1]);
            Y = immediateToBinary(operands[2], 10);
            break;
        case 'ST':
            // Three operands: RT, RS, Y
            RT = registerToBinary(operands[0]);
            RS = registerToBinary(operands[1]);
            Y = immediateToBinary(operands[2], 10);
            break;
        case 'ADD':
            // Three operands: RD, RS, RT
            RD = registerToBinary(operands[0]);
            RS = registerToBinary(operands[1]);
            RT = registerToBinary(operands[2]);
            break;
        case 'INC':
            // Two operands: RD, RS, Y
            RD = registerToBinary(operands[0]);
            RS = registerToBinary(operands[1]);
            Y = immediateToBinary(operands[2], 10);
            break;
        case 'NEG':
            // Two operands: RD, RS
            RD = registerToBinary(operands[0]);
            RS = registerToBinary(operands[1]);
            break;
        case 'SUB':
            // Three operands: RD, RS, RT
            RD = registerToBinary(operands[0]);
            RS = registerToBinary(operands[1]);
            RT = registerToBinary(operands[2]);
            break;
        case 'J':
            // One operand: RS
            RS = registerToBinary(operands[0])
            break;
        case 'BRZ':
            // One operand: RS
            RS = registerToBinary(operands[0])
            break;
        case 'BRN':
            // One operand: RS
            RS = registerToBinary(operands[0])
            break;
        default:
            console.error('Unknown opcode:', opcode);
            break;
    }
    return `${Y}_${RD}_${RS}_${RT}_${OPCODE}`;
}

function registerToBinary(register) {
    // register is in format xN where N is 0-63
    const regNum = parseInt(register.slice(1));
    return regNum.toString(2).padStart(6, '0');
}

function immediateToBinary(immediate, bits) {
    let immNum = parseInt(immediate);
    if (immNum < 0) {
        // Convert to two's complement
        immNum = (1 << bits) + immNum;
    }
    return immNum.toString(2).padStart(bits, '0');
}