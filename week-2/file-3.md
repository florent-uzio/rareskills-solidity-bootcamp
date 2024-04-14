## Revisit the solidity events tutorial. How can OpenSea quickly determine which NFTs an address owns if most NFTs don’t use ERC721 enumerable? Explain how you would accomplish this if you were creating an NFT marketplace

The events are recorded on the blockchain so it would be possible to screen the events from a specific block (or from block 0) and record the events in a database to know exactly what address owns what token.
