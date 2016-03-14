clear all;
load('SpotAndTransactions_2015-04.mat');
m = 4;

for h=1:12
    figure; hold on; title(['Hour: ' num2str(h)]);
    for d=1:28
        filt = strcmp(MARKET_AND_HOUR(:,3),num2str(h)) & DATE_VOL_PRICE_TIME(:,1) == m2xdate(datenum(2015,m,d));
        tmp = DATE_VOL_PRICE_TIME(filt,:);
        tmp(:,4)=x2mdate(tmp(:,4));
        [~,i]=sort(tmp(:,4));
        % tmp(end,:) is the spot price. It is registered as 12:45hrs.
        % Data is visualized as the absolute difference to spot price
        plot(tmp(i,4)-d, tmp(i,3)-tmp(end,3));
    end
    datetick('x','keepticks','keeplimits');
    savefigx(['fig/h' num2str(h)],'png');
end

