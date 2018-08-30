classdef app_class
%APP_CLASS Summary of this class goes here
%   Detailed explanation goes here

    properties (Access = public)
        Title
        Name
        Description
    end

    methods
        function obj = app_class(title, name, description)
            obj.Title = title;
            obj.Name = name;
            obj.Description = description;
        end
    end
end
