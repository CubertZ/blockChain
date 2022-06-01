// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract MyTwitterContract {

	event TweetAdd(address recipient, uint tweetId);
	event TweetDel(uint tweetId, bool deleteStatus);
	event TweetUpdate(address recipient,uint tweetId, bool deleteStatus);

	struct Tweet {
		uint id;
		address tweetAuthor;
		string tweetContent;
		bool deleteStatus;
	}

	Tweet[] private arrayTweets;

	mapping(uint => address) originalAuthor;

	//Method to add a new tweet
	function addTweet(string memory tweetContent, bool deleteStatus) external {
		uint tweetId = arrayTweets.length;
		arrayTweets.push(Tweet(tweetId, msg.sender, tweetContent, deleteStatus));
		originalAuthor[tweetId] = msg.sender;
		emit TweetAdd(msg.sender, tweetId);
	}


	//Method to get all the Tweets
	function getAllTweets() external view returns (Tweet[] memory) {
		Tweet[] memory temporary = new Tweet[](arrayTweets.length);

		uint counter = 0;
		for(uint i=0; i<arrayTweets.length; i++) {
			if(arrayTweets[i].deleteStatus == false) {
				temporary[counter] = arrayTweets[i];
				counter++;
			}
		}

		Tweet[] memory result = new Tweet[](counter);
		for(uint i=0; i<counter; i++) {
			result[i] = temporary[i];
		}
		return result;
	}

	//Method to get only my Tweets
	function getMyTweets() external view returns (Tweet[] memory) {
		Tweet[] memory temporary = new Tweet[](arrayTweets.length);

		uint counter = 0;
		for(uint i=0; i<arrayTweets.length; i++) {
			if(originalAuthor[i] == msg.sender && arrayTweets[i].deleteStatus == false) {
				temporary[counter] = arrayTweets[i];
				counter++;
			}
		}

		Tweet[] memory result = new Tweet[](counter);
		for(uint i=0; i<counter; i++) {
			result[i] = temporary[i];
		}
		return result;
	}
//Method to update a tweet
	function updateTweet(uint tweetId, string memory tweetContent, bool deleteStatus) external {
        if (originalAuthor[tweetId] == msg.sender && arrayTweets[tweetId].deleteStatus == false) {
            uint newTweetId = arrayTweets.length;
            arrayTweets[tweetId].deleteStatus = true;
            arrayTweets.push(Tweet(newTweetId, msg.sender, tweetContent, deleteStatus));
            originalAuthor[newTweetId] = msg.sender;
            emit TweetUpdate(msg.sender, tweetId, deleteStatus);
        }
    }

	//Method to Delete a Tweet
	function deleteTweet(uint tweetId, bool deleteStatus) external {
		if(originalAuthor[tweetId] == msg.sender && arrayTweets[tweetId].deleteStatus == false) {
			arrayTweets[tweetId].deleteStatus = deleteStatus;
			emit TweetDel(tweetId, deleteStatus);
		}
	}


}