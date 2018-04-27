function y = nansem(x)
%     nonanx = x(~isnan(x));
    y = nanstd(x) / sqrt(length(x));
end