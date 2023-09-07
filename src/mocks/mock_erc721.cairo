#[starknet::contract]
mod MockERC721 {
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use openzeppelin::token::erc721::ERC721;

    #[storage]
    struct Storage {}

    #[constructor]
    fn constructor(ref self: ContractState) {
        let name = 'TestNFT';
        let symbol = 'TNFT';

        let mut unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::InternalImpl::initializer(ref unsafe_state, name, symbol);
    }

    #[external(v0)]
    fn name(self: @ContractState) -> felt252 {
        let unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721MetadataImpl::name(@unsafe_state)
    }

    #[external(v0)]
    fn symbol(self: @ContractState) -> felt252 {
        let unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721MetadataImpl::symbol(@unsafe_state)
    }

    #[external(v0)]
    fn balanceOf(self: @ContractState, account: ContractAddress) -> u256 {
        let unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::balance_of(@unsafe_state, account)
    }

    #[external(v0)]
    fn ownerOf(self: @ContractState, token_id: u256) -> ContractAddress {
        let unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::owner_of(@unsafe_state, token_id)
    }


    #[external(v0)]
    fn mint(ref self: ContractState, token_id: u256,) {
        let caller = get_caller_address();

        let mut unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::InternalImpl::_mint(ref unsafe_state, caller, token_id);
    }
}
