function [T,dtav] = diffusion(Lx,Ly,J,K,Dup,Ddown,Dright,Dleft,T0,tf,F)
% DIFFUSION  Adaptive explicit method for non-constant diffusion equation
%   T_t = F + div (D grad T)
% on rectangle (-Lx,Lx) x (-Ly,Ly) with initial condition T0.
% Usage:
%   T = diffusion(Lx,Ly,J,K,Dup,Ddown,Dright,Dleft,T0,tf,F)
% where
%   T     = approximate solution at tf
%   Lx,Ly = half-widths of rectangular domain
%   J,K   = number of points in x,y directions, resp.
%   D*    = (J-1) x (K-1) matrices with diffusivities for "staggered" grid
%   T0    = (J+1) x (K+1) matrix with initial values on regular grid
%   tf    = final time
%   F     <-- OPTIONAL ARGUMENT
%         = (J+1) x (K+1) matrix with heat source on regular grid
% Note: There is no error checking on sizes of D*, T0, F matrices.
% Note: There is no text output.  Restore commented 'fprintf' if desired.
% Note: The input diffusivities could be time-dependent, but they are
%   time-independent in this simplified implementation.  A call-back to
%   a diffusivity function would be one way to implement a time-dependent
%   diffusivity D(t,x,y).
% Example: compare this result to HEATADAPT:
%   >> J = 50;  K = 50;  D = ones(J-1,K-1);
%   >> [x,y] = ndgrid(-1:2/J:1,-1:2/K:1);
%   >> T0 = exp(-30*(x.*x + y.*y));
%   >> T = diffusion(1.0,1.0,J,K,D,D,D,D,T0,0.05);
%   >> surf(x,y,T), shading('interp'), xlabel x, ylabel y
% Used by: SIAFLAT

% spatial grid and initial condition
dx = 2 * Lx / J;    dy = 2 * Ly / K;
[x,y] = ndgrid(-Lx:dx:Lx, -Ly:dy:Ly); % (J+1) x (K+1) grid in x,y plane
T = T0;
if nargin < 11, F = zeros(size(T0)); end  % allows use for nonflat-bed SIA case

%fprintf('  doing explicit steps adaptively on 0.0 < t < %.3f\n',tf)
t = 0.0;    count = 0;
while t < tf
   % stability condition gives time-step restriction
   Dregular = max(max(Dup,Ddown),max(Dleft,Dright));  % array on regular grid
   maxD = max(max(Dregular));  % scalar maximum of D
   dt0 = 0.25 * min(dx,dy)^2 / maxD;
   dt = min(dt0, tf - t);  % do not go past tf
   mu_x = dt / (dx*dx);    mu_y = dt / (dy*dy);
   T(2:J,2:K) = T(2:J,2:K) + ...
       mu_y * Dup    .* ( T(2:J,3:K+1) - T(2:J,2:K)   ) - ...
       mu_y * Ddown  .* ( T(2:J,2:K)   - T(2:J,1:K-1) ) + ...
       mu_x * Dright .* ( T(3:J+1,2:K) - T(2:J,2:K)   ) - ...
       mu_x * Dleft  .* ( T(2:J,2:K)   - T(1:J-1,2:K) );
   T = T + F * dt;
   t = t + dt;
   count = count + 1;
   %fprintf('.')
end
dtav = tf / count;
%fprintf('\n  completed N = %d steps, average dt = %.7f\n',count,tf/count)
%surf(x,y,T),  shading('interp'),  xlabel x,  ylabel y
