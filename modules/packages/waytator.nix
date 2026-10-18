{
  perSystem =
    { inputs', ... }:
    {
      packages.waytator = inputs'.waytator.packages.default;
    };
}
