// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract FunticoNFT is ERC721, ERC721Enumerable, Ownable {
    uint256 private _nextTokenId = 0;
    uint256 public MAX_SUPPLY = 889;
    constructor(
        address initialOwner
    ) ERC721("Funtico Summoners", "FSC") Ownable(initialOwner) {}
    function _baseURI() internal pure override returns (string memory) {
        return "https://nft-meta.funtico.com/api/necromancer/";
    }
    function safeMint(address to) public onlyOwner  {
        require(totalSupply() < MAX_SUPPLY, "Maximum supply reached");
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }
    
    // The following functions are overrides required by Solidity.
    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }
    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }
    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
