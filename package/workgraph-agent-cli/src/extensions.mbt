///|
pub extend WorkspaceRef with Debug::{to_repr}

///|
pub extend WorkspaceRef with Eq::{equal, not_equal}

///|
pub extend ApprovalPolicy with Debug::{to_repr}

///|
pub extend ApprovalPolicy with Eq::{equal, not_equal}

///|
pub extend NetworkPolicy with Debug::{to_repr}

///|
pub extend NetworkPolicy with Eq::{equal, not_equal}

///|
pub extend CodingAgentContinuationError with Debug::{to_repr}

///|
pub extend CodingAgentId with Eq::{equal, not_equal}

///|
pub extend CodingAgentId with Hash::{hash, hash_combine}

///|
pub extend CodingAgentId with Debug::{to_repr}

///|
pub extend IdError with Debug::{to_repr}
