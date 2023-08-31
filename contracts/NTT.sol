// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/PandiaJason/Non-Transferable-Non-Fungible-Tokens/blob/main/contracts/ERC721URIStorage.sol";

contract NTT is ERC721URIStorage {

    address public immutable nttRECIPIENT;

    // tokenID => uri 
    mapping(uint256 => string) public tokensINFO;

    struct tokenTHRESHOLD{
        uint256 tokenTVAL;
        address [] signedAUTH;
    }

    // tokenID => tokenTHRESHOLD 
    mapping(uint256 => tokenTHRESHOLD) public tokensTDATA;


    constructor(address  _nttRECIPIENT) ERC721("Non-Transferable-Token", "NTT") {
    // constructor(address  _nntHolder, string memory name_, string memory symbol_) ERC721(name_, symbol_) {
        nttRECIPIENT = _nttRECIPIENT;
    }

    function uriDATA(uint256 tokenID, string memory uri)
        public returns (string memory )
    {   
        require(registry[msg.sender] == true, "Not an authoritarian" );
        require(bytes(tokensINFO[tokenID]).length == 0, "URI already exits");
        tokensINFO[tokenID]= uri;
        return tokensINFO[tokenID];
    }

    function mintNTT(uint256 tokenID)
        public returns (uint256)
    {
        require( tokensTDATA[tokenID].tokenTVAL >= 2, "Doesn't  met the threshold");
        _mint(nttRECIPIENT, tokenID);
        _setTokenURI(tokenID, tokensINFO[tokenID]);

        return tokenID;
    }

    function multiSIG(uint256  _tokenID)
    public  {
        require(registry[msg.sender] == true, "Not an authoritarian" );
        require( isAuthAlreadySigned(_tokenID, msg.sender ) == false, "AuthAlreadySigned");
        tokensTDATA[_tokenID].tokenTVAL += 1;
        tokensTDATA[_tokenID].signedAUTH.push(msg.sender);
            
    }

    function isAuthAlreadySigned(uint256 tokenID, address signee) 
    public view returns (bool)
    {        
        tokenTHRESHOLD storage signees =  tokensTDATA[tokenID];
        for (uint i=0; i< signees.signedAUTH.length; i++){
            if (signees.signedAUTH[i] == signee){
            return true;}
        }return false;
    }

}
