classdef app_class
%APP_CLASS Summary of this class goes here
%   Detailed explanation goes here

    properties (Access = public)
        Title
        Name
        Description
        Authors
        Script
        ImgSrc
        Link
    end

    methods
        function obj = app_class(title, name, description, authors, script, ImgSrc, Link)
            obj.Title = title;
            obj.Name = name;
            obj.Description = description;
            obj.Authors = authors;
            obj.Script = script;
            obj.ImgSrc = ImgSrc;
            obj.Link = Link;
        end
    end
end
