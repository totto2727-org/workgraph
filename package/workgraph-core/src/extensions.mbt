///|
pub extend GraphBuildError with @debug.Debug::{to_repr}

///|
pub extend GraphValidationError with @debug.Debug::{to_repr}

///|
pub extend RunFailure with @debug.Debug::{to_repr}

///|
pub extend GraphRuntimeError with @debug.Debug::{to_repr}

///|
pub extend CompiledNodeSnapshot with @debug.Debug::{to_repr}

///|
pub extend CompiledGraphSnapshot with @debug.Debug::{to_repr}

///|
pub extend NodeId with Eq::{equal, not_equal}

///|
pub extend NodeId with Hash::{hash, hash_combine}

///|
pub extend NodeId with @debug.Debug::{to_repr}

///|
pub extend RunId with Eq::{equal, not_equal}

///|
pub extend RunId with Hash::{hash, hash_combine}

///|
pub extend RunId with @debug.Debug::{to_repr}

///|
pub extend ResourceKey with Eq::{equal, not_equal}

///|
pub extend ResourceKey with Hash::{hash, hash_combine}

///|
pub extend ResourceKey with @debug.Debug::{to_repr}

///|
pub extend IdError with @debug.Debug::{to_repr}

///|
pub extend Route with @debug.Debug::{to_repr}

///|
pub extend NodeKind with @debug.Debug::{to_repr}

///|
pub extend NodeKind with Eq::{equal, not_equal}

///|
pub extend NodeMetadata with @debug.Debug::{to_repr}

///|
pub extend NodeOutput with @debug.Debug::{to_repr}

///|
pub extend NodeCompletion with @debug.Debug::{to_repr}

///|
pub extend GraphEvent with @debug.Debug::{to_repr}

///|
pub extend DeclaredRouteMetadata with @debug.Debug::{to_repr}

///|
pub extend DeclaredRoute with @debug.Debug::{to_repr}

///|
pub extend RouterMetadata with @debug.Debug::{to_repr}

///|
pub extend ResourceScope with @debug.Debug::{to_repr}

///|
pub extend ResourceScope with Eq::{equal, not_equal}

///|
pub extend ResourceStoreError with @debug.Debug::{to_repr}

///|
pub extend RunConfigurationError with @debug.Debug::{to_repr}

///|
pub extend RunOptions with @debug.Debug::{to_repr}

///|
pub extend RunResult with @debug.Debug::{to_repr}
