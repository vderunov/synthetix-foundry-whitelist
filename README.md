## Usage

### Dependencies Installation

```shell
yarn install
```

### Build

```shell
forge build
```
### Config Your Environment File

Copy env template and fill private keys and addresses in .env

```shell
cp .env.template .env
```
### Environment Config

This command loads variables from the .env file into your current shell session, providing your application access to these variables. Note that you typically need to run this command once for each shell session.

```shell
source .env
```
### Deploy and Verify

|  Parameter | Value |
|---|-------|
|  Network Name |  OP Sepolia |
|  Chain ID |  11155420 |

```shell
forge create --rpc-url $RPC --chain 11155420 --private-key $PK_ADMIN --etherscan-api-key $SEPOLIA_OPTIMISM_ETHERSCAN --verify src/Whitelist.sol:Whitelist
```
## Test interactions

Check `admin` role

```shell
cast call --rpc-url $RPC $WL 'isAdmin(address)(bool)' $AD_ADMIN

# => 'true', when the specified address is granted `admin` role
```
Check `admin` role for AD_TEST1

```shell
cast call --rpc-url $RPC $WL 'isAdmin(address)(bool)' $AD_TEST1

# => 'false', when the specified address is not granted `admin` role
```
Send Ether to AD_TEST1

```shell
cast send --private-key $PK_ADMIN --rpc-url $RPC --value 0.1ether $AD_TEST1

# => transaction details
```
Apply for Whitelist with AD_TEST1

```shell
cast send --rpc-url $RPC --private-key $PK_TEST1 $WL 'applyForWhitelist()'

# => transaction details
```
Check Whitelist `pending` role for AD_TEST1

```shell
cast call --rpc-url $RPC $WL 'isPending(address)(bool)' $AD_TEST1

# => 'true', when the specified address is granted `pending` role
```
Approve Whitelist Application for AD_TEST1

```shell
cast send --rpc-url $RPC --private-key $PK_ADMIN $WL 'approveApplication(address)' $AD_TEST1

# => 'true', when the specified address is given `granted` role
```

Check `granted` role for AD_TEST1

```shell
cast call --rpc-url $RPC $WL 'isGranted(address)(bool)' $AD_TEST1

# => 'true', when the specified address is given `granted` role
```
## Development

### Generate readable ABI

Creates `Whitelist.json` in the project root

```sh
node readable-abi.js out/Whitelist.sol/Whitelist.json
```

### Run tests

```shell
forge test 
```

### Test coverage

```shell
forge coverage 
```
