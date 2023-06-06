methods {
    // Summarizations:
    isSolvent(address _user) returns (bool) => simplified_solvent(_user)
}

ghost simplified_solvent(address) returns bool;
