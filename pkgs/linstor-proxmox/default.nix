{
  lib,
  stdenv,
  fetchFromGitHub,
  perl536,
  pve-storage,
  nix-update-script,
}:

let
  perlDeps = with perl536.pkgs; [
    JSONXS
    RESTClient
    TypesSerialiser
    pve-storage
  ];

  perlEnv = perl536.withPackages (_: perlDeps);
in

perl536.pkgs.toPerlModule (
  stdenv.mkDerivation rec {
    pname = "linstor-proxmox";
    version = "8.0.4";

    src = fetchFromGitHub {
      owner = "LINBIT";
      repo = "linstor-proxmox";
      rev = "v${version}";
      hash = "sha256-aQ9VqQcF9jDGcv2anKPunTTNyS1exJcODt7WkcGxH+o=";
    };

    makeFlags = [
      "DESTDIR=$(out)"
      "PERLDIR=/${perl536.libPrefix}/${perl536.version}"
    ];

    buildInputs = [ perlEnv ];

    passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };

    meta = with lib; {
      description = "Integration pluging bridging LINSTOR to Proxmox VE";
      homepage = "https://github.com/LINBIT/linstor-proxmox";
      changelog = "https://github.com/LINBIT/linstor-proxmox/blob/${src.rev}/CHANGELOG.md";
      license = [ ];
      maintainers = with maintainers; [
        camillemndn
        julienmalka
      ];
      platforms = platforms.linux;
    };
  }
)
