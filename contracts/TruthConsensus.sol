// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./HistoryToken.sol";

contract TruthConsensusPlatform {

  struct EvidenceBlock {
    uint256 id;
    string[] tags;
    address op;
    uint256 cares;
    uint256 topic;
    string uri;
    uint256 startIndex;
    uint256 length;
    uint256 score;
  }

  uint256 private ebCounter = 1;

  mapping(uint256 => mapping(address => bool)) private _topicAddressCares;
  mapping(uint256 => mapping(address => int8)) private _topicAddressVotes;
  mapping(uint256 => EvidenceBlock) private _evidenceBlocks;
  mapping(bytes32 => uint256) private _evidenceUriHashes;
  mapping(address => uint256) private _tegridy;

  HistoryToken public hstk;

  constructor() {
    hstk = new HistoryToken();
  }

  function post(string calldata uri) public {
    reply(uri, 0, 0, 0, 0);
  }

  function reply(string calldata uri, uint256 topic, uint256 startIndex, uint256 length, int8 vote) public {
    bytes32 hash = keccak256(abi.encodePacked(uri, "@", 0, ":", 0));
    require(_evidenceUriHashes[hash] = 0, "Duplicate evidence block");
    require(topic < ebCounter, "Inexistent topic");
    require(vote >= -1 && vote <= 1, "Invalid vote");
    _evidenceUriHashes[hash] = ebCounter;
    _evidenceBlocks[ebCounter].id = ebCounter;
    _evidenceBlocks[ebCounter].op = msg.sender;
    _evidenceBlocks[ebCounter].topic = topic;
    _evidenceBlocks[ebCounter].startIndex = startIndex;
    _evidenceBlocks[ebCounter].length = length;
    if (topic > 0) {
      // TODO: use SafeMath
      _evidenceBlocks[topic].score += vote;
    }
    // TODO: SafeMath here too
    ebCounter++;
    hstk.mint(msg.sender, 2 ether);
  }
}
