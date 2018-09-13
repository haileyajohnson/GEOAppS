classdef app_class
%APP_CLASS Summary of this class goes here
%   Detailed explanation goes here

    properties (Access = public)
        Title
        Name
        Description
        Authors
    end

    methods
        function obj = app_class(title, name, description, authors)
            obj.Title = title;
            obj.Name = name;
            obj.Description = description;
            obj.Authors = authors;
        end
    end
end
