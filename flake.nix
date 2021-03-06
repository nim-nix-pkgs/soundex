{
  description = ''soundex algorithm'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs."soundex-master".dir   = "master";
  inputs."soundex-master".owner = "nim-nix-pkgs";
  inputs."soundex-master".ref   = "master";
  inputs."soundex-master".repo  = "soundex";
  inputs."soundex-master".type  = "github";
  inputs."soundex-master".inputs.nixpkgs.follows = "nixpkgs";
  inputs."soundex-master".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@inputs:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib"];
  in lib.mkProjectOutput {
    inherit self nixpkgs;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
    refs = builtins.removeAttrs inputs args;
  };
}