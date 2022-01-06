{application, simple_cache,
 [{description, "A simple caching system"},
  {vsn, "0.3.0"},
  {modules, [simple_cache,
             sc_app,
             sc_sup,
             sc_store,
             sc_event,
             sc_event_logger]},
  {registered, [sc_sup, sc_event]},
  {applications, [kernel, sasl, stdlib, mnesia]},
  {mod, {sc_app, []}}
 ]}.