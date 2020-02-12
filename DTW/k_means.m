function [centres,post]=k_means(centres,data,kiter)

[dim,data_sz]=size(data');
ncentres=size(centres,1); %簇的数目
[ignore,perm]=sort(rand(1,data_sz)); %产生任意顺序的随机数
perm = perm(1:ncentres); %取前ncentres个作为初始簇中心的序号
centres=data(perm,:); %指定初始中心点
id=eye(ncentres); %Matrix to make unit vectors easy to construct
for n=1:kiter
  % Save old centres to check for termination
  old_centres=centres; %存储旧的中心,便于计算终止条件
  
  % Calculate posteriors based on existing centres
  d2=(ones(ncentres,1)*sum((data.^2)',1))'+...
     ones(data_sz,1)* sum((centres.^2)',1)-2.*(data*(centres')); %计算距离
 
  % Assign each point to nearest centre
  [minvals, index]=min(d2', [], 1);
  post=id(index,:);

  num_points = sum(post, 1);
  % Adjust the centres based on new posteriors
  for j = 1:ncentres
    if (num_points(j) > 0)
      centres(j,:) = sum(data(find(post(:,j)),:), 1)/num_points(j);
    end
  end

  % Error value is total squared distance from cluster centres
  e = sum(minvals);
  if n > 1
    % Test for termination
    if max(max(abs(centres - old_centres))) < 0.0001 & ...
        abs(old_e - e) < 0.0001
      return;
    end
  end
  old_e = e;
end
end