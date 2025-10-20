// SPDX-License-Identifier: Apache-2.0

// modified from https://github.com/circlefin/aptos-cctp/blob/4d8901d11e904d6d8b23dcab3ae513576cc4885d/packages/token_messenger_minter/scripts/deposit_for_burn.move
module cctp_v1_with_executor::cctp_v1_with_executor {
    use aptos_framework::aptos_coin::{AptosCoin};
    use aptos_framework::coin;
    use aptos_framework::fungible_asset::{Metadata};
    use aptos_framework::object::{Self, Object};
    use aptos_framework::primary_fungible_store;
    use executor::executor;
    use executor_requests::executor_requests;
    use token_messenger_minter::token_messenger;

    const SRC_DOMAIN: u32 = 9;
    
    public entry fun deposit_for_burn_entry(
        caller: &signer,
        amount: u64,
        destination_domain: u32,
        mint_recipient: address,
        burn_token: address,
        exec_amount: u64,
        dst_chain: u16, 
        refund_addr: address, 
        signed_quote_bytes: vector<u8>, 
        relay_instructions: vector<u8>,
        transfer_token_fee: u64,
        native_token_fee: u64,
        payee: address,
    ) {
        let token_obj: Object<Metadata> = object::address_to_object(burn_token);
        if (transfer_token_fee > 0) {
            primary_fungible_store::transfer(caller, token_obj, payee, transfer_token_fee);
        };
        if (native_token_fee > 0) {
            let fee_coin = coin::withdraw<AptosCoin>(caller, native_token_fee);
            coin::deposit(payee, fee_coin);
        };
        let asset = primary_fungible_store::withdraw(caller, token_obj, amount);
        let nonce = token_messenger::deposit_for_burn(
            caller,
            asset,
            destination_domain,
            mint_recipient,
        );
        let req = executor_requests::make_cctp_v1_request(SRC_DOMAIN, nonce);
        let exec_coin = coin::withdraw<AptosCoin>(caller, exec_amount);
        executor::request_execution(
            exec_coin,
            dst_chain,
            @0x0, // The executor will derive this.
            refund_addr,
            signed_quote_bytes,
            req,
            relay_instructions,
        );
    }
}
