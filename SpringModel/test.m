function test

  %n_mass = 2*10;
  %n_spring = n_mass + 1;
  % period = [2 3 4 5 8];
  % for ii=1:length(period)
  %   figure;
  %   plotLayers(n_spring, period(ii));
  % end
  
  n_mass = 2*51;
  n_spring = n_mass + 1;
  ratio = [0.1 0.5 0.75 1 1.5 2 10];
  n_layer = 7;
  for ii=1:length(ratio)
    figure;
    plotLayersU(ii, n_spring, n_layer, ratio(ii));
  end

function plotLayers(n_spring, period)

  stiff = true;
  count = 1;
  for i=1:n_spring-1
    x0 = (i-1);
    x1 = i;
    if (mod(count, period) == 0) 
      if (stiff == true)
        stiff = false;
        count = 1;
      else
        stiff = true;
        count = 1;
      end
    end
    count = count + 1;
    if (stiff == true)
      plot([x0 x1 x1 x0 x0], [0 0 1 1 0], 'k-', 'LineWidth', 2); hold on;
    else
      plot([x0 x1 x1 x0 x0], [0 0 0.5 0.5 0], 'k-', 'LineWidth', 2); hold on;
    end
  end
  x0 = (n_spring-1);
  x1 = n_spring;
  plot([x0 x1 x1 x0 x0], [0 0 1 1 0], 'k-', 'LineWidth', 2); hold on;
  axis equal
  axis off

  filenum = num2str(period);
  filename = strcat('LayerElasBar',filenum,'.eps');
  print(gcf, '-depsc', filename);
  
function plotLayersU(plotnum, n_spring, n_layer, ratio_stiff_soft)

  N = n_spring/n_layer;

  n_stiff = ratio_stiff_soft/(1+ratio_stiff_soft)*N;
  n_soft = n_spring - n_stiff;

  count = 0;
  for ii=1:n_spring-1
    x0 = (ii-1);
    x1 = ii;
    count = count + 1;
    if (count < n_stiff)
      plot([x0 x1 x1 x0 x0], [0 0 1 1 0], 'k-', 'LineWidth', 2); hold on;
    else
      plot([x0 x1 x1 x0 x0], [0 0 0.5 0.5 0], 'k-', 'LineWidth', 2); hold on;
    end
    if (count > N)
      count = 0;
    end
  end
  x0 = (n_spring-1);
  x1 = n_spring;
  plot([x0 x1 x1 x0 x0], [0 0 1 1 0], 'k-', 'LineWidth', 2); hold on;
  axis equal
  axis off
  
  filenum = num2str(plotnum);
  filename = strcat('LayerElasBarRatio',filenum,'.eps');
  print(gcf, '-depsc', filename);
