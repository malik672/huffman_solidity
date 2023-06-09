/// @title Huffman encoder and decoder in solidity
/// @notice SPDX-License-Identifier: MIT
/// @author Malik_dev /      


pragma solidity ^0.8.13;

contract Huffman {

  /*//////////////////////////////////////////////////////////////
                                STRUCT
  //////////////////////////////////////////////////////////////*/
  struct HeapNode {
    bytes1 char;
    uint8 freq;
    uint256 index; // Added index property for heap operations
  }

  HeapNode[] private Heap;

  /*//////////////////////////////////////////////////////////////
                              MAPPINGS
  //////////////////////////////////////////////////////////////*/
  mapping(bytes1  => uint8 ) private maps;

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
        Heap.push(HeapNode(bytes1(i), freq, keys));
        ++keys;
      }
    }
  }

  /// @notice merging of nodes
  /// @dev 
  function mergeNodes() private {
    while(Heap.length > 1){
     
    }
  }

}
