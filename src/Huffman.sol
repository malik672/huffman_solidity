/// @title Huffman encoder and decoder in solidity
/// @notice SPDX-License-Identifier: MIT
/// @author Malik_dev /      


pragma solidity ^0.8.13;

contract Huffman {

  /*//////////////////////////////////////////////////////////////
                                STRUCT
  //////////////////////////////////////////////////////////////*/
  struct HeapNode {
    bytes1 char;//character 
    uint8 freq; // Frequency at which character they occur;
    uint index; // Added index property for heap operations
    uint left;  // Left indices of the node
    uint right; // right side of the node

  }

  HeapNode[] private Heap;

  /*//////////////////////////////////////////////////////////////
                              MAPPINGS
  //////////////////////////////////////////////////////////////*/
  //maps is used to store the frequency of characters
  mapping(bytes1  => uint8) private maps;
  //codes is used to store the huffman codes generated during compression
  mapping(bytes1 => bytes) private codes;

  /*//////////////////////////////////////////////////////////////
                         FUNCTIONS
  //////////////////////////////////////////////////////////////*/

  /// @notice creates a frequency for occuring characters.
  /// @dev 
  /// @param text array of bytes
  function buildFrequencyMap(bytes memory text) private {
    //length of bytes array
    uint length = text.length;
    for(uint i; i < length; ++i){
        maps[text[i]] = maps[text[i]] == 0 ? 0 : ++maps[text[i]];
    }
  }

  /// @notice build a heap using mapped characters
  /// @dev 
  function buildHeap() private {
    uint keys;
    for(uint8 i; i <= 255 ; ++i){
      uint8 freq = maps[bytes1(i)];
      if(freq > 0) {
        Heap.push(HeapNode(bytes1(i), freq, keys, 0, 0));
        ++keys;
      }
    }
  }

  /// @notice merging of nodes
  /// @dev 
  function mergeNodes() private {
    uint length = Heap.length;
    uint i;
    while(length > 1){
      //Sort Heap from smallest to the biggest
      sortHeap();
      //get the nodes with lowest frequencies
      HeapNode memory node1 = Heap[0];
      HeapNode memory node2 = Heap[1];

      //merge the node and create a new node
      HeapNode memory mergedNode = HeapNode(0, node1.freq + node2.freq, length, node1.index, node2.index);
    
       //Update the merged node index
       mergedNode.index = 1;//this is likely to be wrong

      //upadte mergedNode into heap
      Heap[1] = mergedNode;

      //remove the first element from the heap since it has been merged
      delete Heap[0];

      //update the length
      --length;
     
    }
  }
  
  ///@param root takes a root node
  ///@param preChar present character
  function generateCodes(HeapNode memory root, bytes memory preChar) private {
    bytes1 char;
    bytes memory charBytes;
    if(root.char != 0){
      char = root.char;
      charBytes = new bytes(1);
      charBytes[0] = char;
      codes[char] = preChar;
      return;
    }

    // Recursively generate codes for left and right subtrees
    if(root.left < Heap.length){ 
      generateCodes(Heap[root.left], (abi.encodePacked(preChar, '0')));
    }

    if (root.right < Heap.length) {
      generateCodes(Heap[root.right], (abi.encodePacked(preChar, '1')));
    } 
  }

  ///
  ///@dev made virtual incase you want to override visibility
  ///@param str string to be compressed
  function compress(bytes memory str) public virtual returns(bytes memory){
    buildFrequencyMap(str);
    buildHeap();
    mergeNodes();
    HeapNode memory root = Heap[0];
    generateCodes(root, "");
    bytes memory compressedText = new bytes(str.length * 8);
    uint compressedLength = 0;
    bytes1 char;
    for(uint i; i < str.length; ++i){
      bytes memory code = codes[str[i]];
      bytes memory codeBytes = code;

      for(uint j; j < codeBytes.length; ++j){
        compressedText[++compressedLength] = codeBytes[j];
      }
    }
    bytes memory compressedBytes = new bytes(compressedLength);
    for (uint256 i = 0; i < compressedLength; ++i) {
      compressedBytes[i] = compressedText[i];
    }
  
    return compressedText;
  }

  function decompress(bytes memory encodedStr) public view returns(bytes memory){
    bytes memory decodedStr = new bytes(encodedStr.length);
    uint256 decodedlength = 0;
    bytes memory currentCode = "";

  for(uint i; i < encodedStr.length; ++i){
    currentCode = abi.encodePacked(currentCode, encodedStr);
    bytes1 currentByte = bytes1(encodedStr[i]);
    

    if(codes[currentByte].length > 0){
      bytes memory charByte = codes[currentByte];

      for(uint j; j < charByte.length; ++j){
        decodedStr[++decodedlength] = charByte[j];
      }
      currentCode = "";
    }
  }
    bytes memory finalDecodedStr = new bytes(decodedlength);
    for (uint256 i; i < decodedlength; ++i) {
      finalDecodedStr[i] = decodedStr[i];
    }
     return finalDecodedStr;
  }

  //sort array using bubble sort method
  function sortHeap() private {
    uint length = Heap.length;
    bool swapped;
    for(uint i; i < length - 1; ++i){
      swapped = false;
      for(uint j; j < length - i - 1; ++j){
        //Swap the nodes if the frequency is greater
        if(Heap[j].freq > Heap[j + 1].freq){
          //Swap the nodes if the frequency is greater
          HeapNode memory temp = Heap[j];
          Heap[j] = Heap[j + 1];
          Heap[j + 1] = temp;
          swapped = true;
        }
      }
      //if no  swap were made break
      if(!swapped){
        break;
      }
    }
  }

}
