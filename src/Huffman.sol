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
    uint8 freq; // Frequency at which they occur;
    uint index; // Added index property for heap operations
    uint left;  // Left indices of the node
    uint right; // right side of the node

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
    
      //upadte mergedNode into heap
      Heap[1] = mergedNode;

      //remove the first element from the heap since it has been merged
      delete Heap[0];

      //Update the merged node index
      mergedNode.index = 1;//this is likely to be wrong

    }
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
