% Test um minimalen Index herauszufinden

A = [77;85;94;2;11;18;20;21;22;29;38;44;50;55;70];

[~,L] = min(mod(laenge + ampel - A - 1,laenge));