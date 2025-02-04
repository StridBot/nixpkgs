{ lib, buildGo118Module, fetchFromGitHub, nixosTests }:

buildGo118Module rec {
  pname = "corerad";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "sha256-i7TvXP8aKW5izWv1AATvc5aP5qO3WxM09AiN5NRRylY=";
  };

  vendorSha256 = "sha256-+9KjgbKuAJexdGEKu9hIsHfHsVbKeB5ZtSgFzM2/bOI=";

  doCheck = false;

  # Since the tarball pulled from GitHub doesn't contain git tag information,
  # we fetch the expected tag's timestamp from a file in the root of the
  # repository.
  preBuild = ''
    buildFlagsArray=(
      -ldflags="
        -X github.com/mdlayher/corerad/internal/build.linkTimestamp=$(<.gittagtime)
        -X github.com/mdlayher/corerad/internal/build.linkVersion=v${version}
      "
    )
  '';

  passthru.tests = {
    inherit (nixosTests) corerad;
  };

  meta = with lib; {
    homepage = "https://github.com/mdlayher/corerad";
    description = "Extensible and observable IPv6 NDP RA daemon";
    license = licenses.asl20;
    maintainers = with maintainers; [ mdlayher ];
  };
}
