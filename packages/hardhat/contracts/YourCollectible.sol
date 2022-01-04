pragma solidity >=0.6.0 <0.7.0;
// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract YourCollectible is ERC721, Ownable {

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // struct to store each token's traits
  struct SheepWolf {
    bool isSheep;
  }

  mapping(uint256 => SheepWolf) public tokenTraits;

  constructor() public ERC721("YourCollectible", "YCB") {
    _setBaseURI("https://ipfs.io/ipfs/");
  }

    function mintItem(address to, string memory tokenURI)
      public
      returns (uint256)
    {
      _tokenIds.increment();

      uint256 id = _tokenIds.current();
      _mint(to, id);
      _setTokenURI(id, tokenURI);

      uint256 seed = random(id);
      // 33% change of minting a wolf
      tokenTraits[id] = SheepWolf((seed & 0xFFFF) % 2 != 0);

      return id;
    }

    /** READ */

    function getTokenTraits(uint256 tokenId) external view returns (SheepWolf memory) {
      return tokenTraits[tokenId];
    }

    /**
    * generates a pseudorandom number
    * @param seed a value ensure different outcomes for different sources in the same block
    * @return a pseudorandom value
    */
    function random(uint256 seed) internal view returns (uint256) {
      return uint256(keccak256(abi.encodePacked(
        tx.origin,
        blockhash(block.number - 1),
        block.timestamp,
        seed
      )));
    }
}

