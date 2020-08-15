# RunTheNumbers
 audit the total bitcoin supply at future block height using your full node

This is a very simple script that runs in the command line. It's intended to be easy enough to use that anyone with a Bitcoin node can participate without having extensive technical knowledge, but you do need a full node such as Bitcoin Core to participate. If you are a Windows user, the process requires extra steps because this script is designed for Linux and Mac operating systems.


### Linux/MacOS users

1. Download `runthenumbers.sh` or save the raw text to a new file.

2. Copy the script to the machine that is running your node.

3. Locate your [bitcoin.conf file](https://en.bitcoin.it/wiki/Data_directory).

    a. If your data directory doesn't have a bitcoin.conf file, create a new text file and save it as `bitcoin.conf`.

    b. If your bitcoin.conf file doesn't have the `rpcuser` and `rpcpassword` variables, go ahead and add them, save the file, and **restart your node**. They should look like this:

  `rpcuser=any_username`

  `rpcpassword=any_password`

4. Edit the script you downloaded so that the `USERNAME` and `PASSWORD` variables match your `rpcuser` and `rpcpassword` variables in your bitcoin.conf file.

5. Also edit the `TARGET_BLOCK` variable to a future block date. Ideally you will select the same block to audit as other people, so that you can all compare results at the same time.

6. Open your command line or Terminal application. Navigate to the directory where you saved the script by using `cd` to *change directory*, followed by the file path to the script folder.

    `cd /path/to/folder`

7. Run the script:

    `sh runthenumbers.sh` 

    or

    `bash runthenumbers.sh`

If the script runs successfully, you should see something like this:

  `643410/643600: 190 blocks remaining`

The script will listen to your node for new blocks and count down accordingly. Once the target block height is reached, the script will call `gettxoutsetinfo` which will return results like this:

    {
      "height": 643600,
      "bestblock": "0000000000000000000f44e44ac72da83c661ab0fc647ad0d3ba285439f591e0",
      "transactions": 40707898,
      "txouts": 66413003,
      "bogosize": 4988534879,
      "hash_serialized_2": "ea57531c0cdf6a0e6d363164443a35ce245cf1b4e9082070480e3801d1c6a1ef",
      "disk_size": 4443424620,
      "total_amount": 18459823.37870112
    }

See that `total_amount` line? You just verified exactly how many bitcoin exist right now!

Take a screenshot of the output and post your results to social media using the [#RunTheNumbers](https://twitter.com/search?q=%23RunTheNumbers&src=typed_query&f=live) hashtag to compare the output of your node with that of your friends' nodes.

https://twitter.com/BashCo_/status/1294183464611254272