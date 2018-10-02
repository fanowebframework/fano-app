unit RouterCollectionImpl;

interface

uses contnrs, RouteHandlerIntf;

type
    //Route data for HTTP GET, PUT, POST, DELETE, PATCH, HEAD, OPTIONS
    TRouteRec = record
        getRoute : IRouteHandler;
        postRoute : IRouteHandler;
        putRoute : IRouteHandler;
        patchRoute : IRouteHandler;
        deleteRoute : IRouteHandler;
        optionsRoute : IRouteHandler;
        headRoute : IRouteHandler;
    end;

    PRouteRec = ^TRouteRec;

    TRouteList = TFPHashList<PRouteRec>;

    {------------------------------------------------
     interface for any class that can set http verb
     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    TRouteCollection = class(TInterfacedObject, IRouteCollection, IRouteFinder)
    private
        routeList : TRouteList;

        function resetRouteData(const routeData : PRouteRec) : PRouteRec;
        procedure destroyRouteData(var routeData : PRouteRec);
        function getRouteHandler(const requestMethod : string; const routeData :PRouteRec) : IRouteHandler;
    public
        constructor create(const routes : TRouteList);
        destructor destroy(); override;

        //HTTP GET Verb handler
        function get(
            const routeName: string;
            const routeHandler : IRouteHandler
        ) : IRouteCollection;

        //HTTP POST Verb handler
        function post(
            const routeName: string;
            const routeHandler : IRouteHandler
        ) : IRouteCollection;

        //HTTP PUT Verb handler
        function put(
            const routeName: string;
            const routeHandler : IRouteHandler
        ) : IRouteCollection;

        //HTTP DELETE Verb handler
        function delete(
            const routeName: string;
            const routeHandler : IRouteHandler
        ) : IRouteCollection;

        //HTTP HEAD Verb handler
        function head(
            const routeName: string;
            const routeHandler : IRouteHandler
        ) : IRouteCollection;

        //HTTP OPTIONS Verb handler
        function options(
            const routeName: string;
            const routeHandler : IRouteHandler
        ) : IRouteCollection;

        function find(const routeName: string) : IRouteHandler;
    end;

implementation

    constructor TRouteCollection.create(const routes : TRouteList);
    begin
       self.routeList := routes;
    end;

    function TRouteCollection.resetRouteData(const routeData : PRouteRec) : PRouteRec;
    begin
       routeData^.getRoute := nil;
       routeData^.postRoute := nil;
       routeData^.putRoute := nil;
       routeData^.patchRoute := nil;
       routeData^.deleteRoute := nil;
       routeData^.optionsRoute := nil;
       routeData^.headRoute := nil;
       result := routeData;
    end;

    procedure TRouteCollection.destroyRouteData(var routeData : PRouteRec);
    begin
       routeData := resetRouteData(routeData);
       dispose(routeData);
    end;

    destructor TRouteCollection.destroy();
    var i, len:integer;
       routeData :PRouteRec;
    begin
       len := self.routeList.count();
       for len-1 downto 0 do
       begin
          routeData := self.routeList.items[i];
          destroyRouteData(routeData);
          self.routeList.delete(i);
       end;
    end;

    function TRouteCollection.createEmptyRouteData(const routeName: string) : PRouteRec;
    var routeData : PRouteRec;
    begin
       //route not yet found, create new data
       new(routeData);
       routeData := resetRouteData(routeData);
       self.routeList.add(routeName, routeData);
       result := routeData;
    end;

    function TRouteCollection.findRouteData(const routeName: string) : PRouteRec;
    var routeData : PRouteRec;
    begin
        routeData := self.routeList.find(routeName);
        if (routeData = nil) then
        begin
           //route not yet found, create new data
           result := createEmptyRouteData(routeName);
        end else
        begin
           result := routeData
        end;
    end;

    //HTTP GET Verb handler
    function TRouteCollection.get(
        const routeName: string;
        const routeHandler : IRouteHandler
    ) : IRouteCollection;
    var routeData : PRouteRec;
    begin
        routeData := findRouteData(routeName);
        routeData^.getRoute := routeHandler;
        result := self;
    end;

    //HTTP POST Verb handler
    function TRouteCollection.post(
        const routeName: string;
        const routeHandler : IRouteHandler
    ) : IRouteCollection;
    var routeData : PRouteRec;
    begin
       routeData := findRouteData(routeName);
       routeData^.postRoute := routeHandler;
       result := self;
    end;

    //HTTP PUT Verb handler
    function TRouteCollection.put(
        const routeName: string;
        const routeHandler : IRouteHandler
    ) : IRouteCollection;
    var routeData : PRouteRec;
    begin
       routeData := findRouteData(routeName);
       routeData^.putRoute := routeHandler;
       result := self;
    end;

    //HTTP PATCH Verb handler
    function TRouteCollection.patch(
        const routeName: string;
        const routeHandler : IRouteHandler
    ) : IRouteCollection;
    var routeData : PRouteRec;
    begin
       routeData := findRouteData(routeName);
       routeData^.patchRoute := routeHandler;
       result := self;
    end;

    //HTTP DELETE Verb handler
    function TRouteCollection.delete(
        const routeName: string;
        const routeHandler : IRouteHandler
    ) : IRouteCollection;
    var routeData : PRouteRec;
    begin
       routeData := findRouteData(routeName);
       routeData^.deleteRoute := routeHandler;
       result := self;
    end;

    //HTTP HEAD Verb handler
    function TRouteCollection.head(
        const routeName: string;
        const routeHandler : IRouteHandler
    ) : IRouteCollection;
    var routeData : PRouteRec;
    begin
       routeData := findRouteData(routeName);
       routeData^.headRoute := routeHandler;
       result := self;
    end;

    //HTTP HEAD Verb handler
    function TRouteCollection.options(
        const routeName: string;
        const routeHandler : IRouteHandler
    ) : IRouteCollection;
    var routeData : PRouteRec;
    begin
       routeData := findRouteData(routeName);
       routeData^.optionsRoute := routeHandler;
       result := self;
    end;

    function TRouteCollection.getRouteHandler(const requestMethod : string; const routeData :PRouteRec) : IRouteHandler;
    var routeHandler ; IRouteHandler;
    begin
       routeHandler := nil;
       case requestMethod of
            'GET' : routeHandler := routeData^.getRoute;
            'POST' : routeHandler := routeData^.postRoute;
            'PUT' : routeHandler := routeData^.putRoute;
            'DELETE' : routeHandler := routeData^.deleteRoute;
            'PATCH' : routeHandler := routeData^.patchRoute;
            'OPTIONS' : routeHandler := routeData^.optionsRoute;
            'HEAD' : routeHandler := routeData^.headRoute;
       end;
       result := routeHandler
    end;

    function TRouteCollection.find(const requestMethod : string; const routeName: string) : IRouteHandler;
    var routeData : PRouteRec;
    begin
       routeData := self.routeList.find(routeName);
       if (routeData = nil) then
       begin
          result := nil;
       end else
       begin
          result := getRouteHandler(requestMethod, routeData);
       end;
    end;

end.