import { MerkleTree } from "merkletreejs";
import keccak256 from "keccak256";

// the allowed addresses generated randomly
const addresses = [
  "0x375044A8413e9A60308eA41d4a51Bd4aC01A10a4",
  "0x58BCdCeF2f082591109a761C619DbFe8b06180E3",
  "0xADC984064cC1b0016117102D9821302f09976039",
  "0x56Cf3C4E0cB94A341eA613839362EC6581C7B443",
  "0x2866ce6073968f71DaC9A18A700D064fF849E248",
  "0x2269D8fE54b1dC7761A69570F4c0230cb025Faed",
  "0x868E257bD365D6Da52e2307f6cEDd7cb80b69610",
  "0xb5Fe7c3D0fB1AF677845236F500F2fef769c308A",
  "0x9f0A3F85bCCb8C679308Dff711F29EBebfeE9d04",
  "0x967Ab4550727E9993DF856EE20368f10Ab0fF6f8",
];

// Convert buffer to hexadecimal
const buf2hex = (x: Buffer) => `0x${x.toString("hex")}`;

// For the smart contract
const generateProofFromAddress = (address: string) => {
  const leaf = keccak256(address);
  console.log(`Leaf: ${buf2hex(leaf)}`);

  const proof = tree.getProof(leaf);
  const proofData = proof.map((x) => buf2hex(x.data));
  console.log(
    `Proof Data for smart contract below, make sure there are no spaces and " instead of ':`
  );
  console.log(proofData);
};

const generateLeavesFromAddresses = (addresses: string[]) => {
  return addresses.map((x) => keccak256(x));
};

const generateRoot = (tree: MerkleTree) => {
  const root = tree.getRoot();

  console.log(`Merkle Root for smart contract: ${buf2hex(root)}`);

  return root;
};

const verify = (proof: any[], leaf: string | Buffer, root: string | Buffer) => {
  return tree.verify(proof, leaf, root);
};

const leaves = generateLeavesFromAddresses(addresses);

const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
generateRoot(tree);
generateProofFromAddress(addresses[0]);
