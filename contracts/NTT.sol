// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/PandiaJason/Non-Transferable-Non-Fungible-Tokens/blob/main/contracts/ERC721URIStorage.sol";

/**
* @dev Implementation of https://github.com/PandiaJason/Non-Transferable-Non-Fungible-Tokens 
* Non_Transferable Token with MultiSig Scheme
* {Modified Extention of ERC721}.
*/

contract NTT is ERC721URIStorage {
    // immutable nttRECIPIENT address to keep NTT
    address public immutable nttRECIPIENT;

    // Mapping of tokenID => uri 
    mapping(uint256 => string) public tokensINFO;

    struct tokenTHRESHOLD{
        uint256 tokenTVAL;
        address [] signedAUTH;
    }

    // Mapping of tokenID => tokenTHRESHOLD 
    mapping(uint256 => tokenTHRESHOLD) public tokensTDATA;


    constructor(address  _nttRECIPIENT) ERC721("Non-Transferable-Token", "NTT") {
    // constructor(address  _nntHolder, string memory name_, string memory symbol_) ERC721(name_, symbol_) {
        nttRECIPIENT = _nttRECIPIENT;
    }
    
    /**
    * @dev Implementation of function uriDATA
    * verifies msg.sender, uri length and set uri
    * return uriDATA {string}
    */
    function uriDATA(uint256 tokenID, string memory uri)
        public returns (string memory )
    {   
        require(registry[msg.sender] == true, "Not an authoritarian" );
        require(bytes(tokensINFO[tokenID]).length == 0, "URI already exits");
        tokensINFO[tokenID]= uri;
        return tokensINFO[tokenID];
    }

    /**
    * @dev Implementation of function mintNTT
    * verifies msg.sender, uri length, tokenTVAL and 
    * trigers mint, setTokenURI 
    * return tokenID {uint256}
    */
    function mintNTT(uint256 tokenID)
        public returns (uint256)
    {
        require(bytes(tokensINFO[tokenID]).length != 0, "URI doesn't exits");
        require( tokensTDATA[tokenID].tokenTVAL >= 2, "Doesn't  met the threshold");
        _mint(nttRECIPIENT, tokenID);
        _setTokenURI(tokenID, tokensINFO[tokenID]);

        return tokenID;
    }


    /**
    * @dev Implementation of function multiSIG
    * verifies msg.sender, uri length, isAuthAlreadySigned and 
    * appends tokenTVAL by 1, & signedAUTH
    */
    function multiSIG(uint256  _tokenID)
    public  {
        require(bytes(tokensINFO[_tokenID]).length != 0, "URI doesn't exits");
        require(registry[msg.sender] == true, "Not an authoritarian" );
        require( isAuthAlreadySigned(_tokenID, msg.sender ) == false, "AuthAlreadySigned");
        tokensTDATA[_tokenID].tokenTVAL += 1;
        tokensTDATA[_tokenID].signedAUTH.push(msg.sender);
            
    }

    /**
    * @dev Implementation of function isAuthAlreadySigned
    * struct tokenTHRESHOLD retrived from the storage
    * iterate the specific tokenTDATA and check signee or not
    * bool return true or false
    */
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
