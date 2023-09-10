#[starknet::contract]
mod MockERC721 {
    use starknet::ContractAddress;
    use mock_token::utils::store_felt252_array::StoreFelt252Array;
    use openzeppelin::token::erc721::ERC721;
    use alexandria_ascii::interger::ToAsciiArrayTrait;
    use alexandria_data_structures::array_ext::ArrayTraitExt;

    #[storage]
    struct Storage {
        _base_uri: Array<felt252>,
        _token_uri: LegacyMap<u256, Array<felt252>>,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let name = 'Mock ERC721';
        let symbol = 'M721';

        let mut unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::InternalImpl::initializer(ref unsafe_state, name, symbol);
    }

    //
    // ERC721
    // 

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
    fn safeTransferFrom(
        ref self: ContractState,
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
        data: Span<felt252>,
    ) {
        let mut unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::safe_transfer_from(ref unsafe_state, from, to, token_id, data);
    }

    #[external(v0)]
    fn transferFrom(
        ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256,
    ) {
        let mut unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::transfer_from(ref unsafe_state, from, to, token_id);
    }

    #[external(v0)]
    fn approve(ref self: ContractState, approved: ContractAddress, token_id: u256,) {
        let mut unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::approve(ref unsafe_state, approved, token_id);
    }

    #[external(v0)]
    fn setApprovalForAll(ref self: ContractState, operator: ContractAddress, approved: bool,) {
        let mut unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::set_approval_for_all(ref unsafe_state, operator, approved);
    }

    #[external(v0)]
    fn getApproved(self: @ContractState, token_id: u256,) -> ContractAddress {
        let unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::get_approved(@unsafe_state, token_id)
    }

    #[external(v0)]
    fn isApprovedForAll(
        self: @ContractState, owner: ContractAddress, operator: ContractAddress,
    ) -> bool {
        let unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::ERC721Impl::is_approved_for_all(@unsafe_state, owner, operator)
    }

    //
    // ERC721Metadata
    //

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
    fn tokenURI(self: @ContractState, token_id: u256) -> Array<felt252> {
        let unsafe_state = ERC721::unsafe_new_contract_state();
        assert(ERC721::InternalImpl::_exists(@unsafe_state, token_id), 'ERC721: invalid token ID');
        self._token_uri.read(token_id)
    }

    #[external(v0)]
    fn setBaseURI(ref self: ContractState, base_uri: Array<felt252>) {
        self._base_uri.write(base_uri);
    }

    #[external(v0)]
    fn baseURI(self: @ContractState) -> Array<felt252> {
        self._base_uri.read()
    }

    #[internal]
    fn _set_token_uri(ref self: ContractState, token_id: u256) {
        let mut uri = self._base_uri.read();
        let mut token_id_felt252: Array<felt252> = token_id.to_ascii_array();
        uri.append_all(ref token_id_felt252);

        let unsafe_state = ERC721::unsafe_new_contract_state();
        assert(ERC721::InternalImpl::_exists(@unsafe_state, token_id), 'ERC721: invalid token ID');
        self._token_uri.write(token_id, uri);
    }

    //
    // ERC721Mineable
    //

    // mint after setting the base uri
    #[external(v0)]
    fn mint(ref self: ContractState, to: ContractAddress, token_id: u256) {
        let mut unsafe_state = ERC721::unsafe_new_contract_state();
        ERC721::InternalImpl::_mint(ref unsafe_state, to, token_id);
        _set_token_uri(ref self, token_id);
    }
}
